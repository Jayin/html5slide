;(function() {

	//------------------------------
	// Mesh Properties
	//------------------------------
	var MESH = {
		width: 1.2,
		height: 1.2,
		depth: 10,
		segments: 16,
		slices: 8,
		xRange: 0.8,
		yRange: 0.1,
		zRange: 1.0,
		ambient: '#e1e1e1',
		diffuse: '#FFFFFF',
		speed: 0.002
	};

	//------------------------------
	// Light Properties
	//------------------------------
	var LIGHT = {
		count: 1,
		xyScalar: 1,
		zOffset: 80,
		ambient: '#E8E8E8',
		diffuse: '#878787',
		speed: 0.001,
		gravity: 600,
		dampening: 0.95,
		minLimit: 10,
		maxLimit: null,
		minDistance: 400,
		maxDistance: 400,
		autopilot: false,
		draw: false,
		bounds: FSS.Vector3.create(),
		step: FSS.Vector3.create(
			Math.randomInRange(0.2, 1.0),
			Math.randomInRange(0.2, 1.0),
			Math.randomInRange(0.2, 1.0)
		)
	};

	//------------------------------
	// Render Properties
	//------------------------------
	var WEBGL = 'webgl';
	var CANVAS = 'canvas';
	var SVG = 'svg';
	var RENDER = {
		renderer: CANVAS
	};

	//------------------------------
	// Export Properties
	//------------------------------
	var EXPORT = {
		width: 2000,
		height: 1000,
		drawLights: false,
		minLightX: 0.4,
		maxLightX: 0.6,
		minLightY: 0.2,
		maxLightY: 0.4,
		export: function() {
			var l, x, y, light,
				depth = MESH.depth,
				zOffset = LIGHT.zOffset,
				autopilot = LIGHT.autopilot,
				scalar = this.width / renderer.width;

			LIGHT.autopilot = true;
			LIGHT.draw = this.drawLights;
			LIGHT.zOffset *= scalar;
			MESH.depth *= scalar;

			resize(this.width, this.height);

			for (l = scene.lights.length - 1; l >= 0; l--) {
				light = scene.lights[l];
				x = Math.randomInRange(this.width * this.minLightX, this.width * this.maxLightX);
				y = Math.randomInRange(this.height * this.minLightY, this.height * this.maxLightY);
				FSS.Vector3.set(light.position, x, this.height - y, this.lightZ);
				FSS.Vector3.subtract(light.position, center);
			}

			update();
			render();

			switch (RENDER.renderer) {
				case WEBGL:
					window.open(webglRenderer.element.toDataURL(), '_blank');
					break;
				case CANVAS:
					window.open(canvasRenderer.element.toDataURL(), '_blank');
					break;
				case SVG:
					var data = encodeURIComponent(output.innerHTML);
					var url = "data:image/svg+xml," + data;
					window.open(url, '_blank');
					break;
			}

			LIGHT.draw = true;
			LIGHT.autopilot = autopilot;
			LIGHT.zOffset = zOffset;
			MESH.depth = depth;

			resize(container.offsetWidth, container.offsetHeight);
		}
	};


	//------------------------------
	// Global Properties
	//------------------------------
	var now, start = Date.now();
	var center = FSS.Vector3.create();
	var attractor = FSS.Vector3.create();
	var container = document.getElementById('container');
	var output = document.getElementById('output');
	var renderer, scene, mesh, geometry, material;
	var webglRenderer, canvasRenderer, svgRenderer;
	var gui, autopilotController;

	//------------------------------
	// Methods
	//------------------------------
	function initialise() {
		createRenderer();
		createScene();
		createMesh();
		createLights();
		addEventListeners();
		resize(container.offsetWidth, container.offsetHeight);
		animate();
	}

	function createRenderer() {
		webglRenderer = new FSS.WebGLRenderer();
		canvasRenderer = new FSS.CanvasRenderer();
		svgRenderer = new FSS.SVGRenderer();
		setRenderer(RENDER.renderer);
	}

	function setRenderer(index) {

		switch (index) {
			case WEBGL:
				renderer = webglRenderer;
				break;
			case CANVAS:
				renderer = canvasRenderer;
				break;
			case SVG:
				renderer = svgRenderer;
				break;
		}
		renderer.setSize(container.offsetWidth, container.offsetHeight);
		output.appendChild(renderer.element);
	}

	function createScene() {
		scene = new FSS.Scene();
	}

	function createMesh() {
		scene.remove(mesh);
		renderer.clear();
		geometry = new FSS.Plane(MESH.width * renderer.width, MESH.height * renderer.height, MESH.segments, MESH.slices);
		material = new FSS.Material(MESH.ambient, MESH.diffuse);
		mesh = new FSS.Mesh(geometry, material);
		scene.add(mesh);

		// Augment vertices for animation
		var v, vertex;
		for (v = geometry.vertices.length - 1; v >= 0; v--) {
			vertex = geometry.vertices[v];
			vertex.anchor = FSS.Vector3.clone(vertex.position);
			vertex.step = FSS.Vector3.create(
				Math.randomInRange(0.2, 1.0),
				Math.randomInRange(0.2, 1.0),
				Math.randomInRange(0.2, 1.0)
			);
			vertex.time = Math.randomInRange(0, Math.PIM2);
		}
	}

	function createLights() {
		var l, light;
		for (l = scene.lights.length - 1; l >= 0; l--) {
			light = scene.lights[l];
			scene.remove(light);
		}
		renderer.clear();
		for (l = 0; l < LIGHT.count; l++) {
			light = new FSS.Light(LIGHT.ambient, LIGHT.diffuse);
			light.ambientHex = light.ambient.format();
			light.diffuseHex = light.diffuse.format();
			scene.add(light);

			// Augment light for animation
			light.mass = Math.randomInRange(0.5, 1);
			light.velocity = FSS.Vector3.create();
			light.acceleration = FSS.Vector3.create();
			light.force = FSS.Vector3.create();

			// Ring SVG Circle
			light.ring = document.createElementNS(FSS.SVGNS, 'circle');
			light.ring.setAttributeNS(null, 'stroke', light.ambientHex);
			light.ring.setAttributeNS(null, 'stroke-width', '0.5');
			light.ring.setAttributeNS(null, 'fill', 'none');
			light.ring.setAttributeNS(null, 'r', '10');

			// Core SVG Circle
			light.core = document.createElementNS(FSS.SVGNS, 'circle');
			light.core.setAttributeNS(null, 'fill', light.diffuseHex);
			light.core.setAttributeNS(null, 'r', '4');
		}
	}

	function resize(width, height) {
		renderer.setSize(width, height);
		FSS.Vector3.set(center, renderer.halfWidth, renderer.halfHeight);
		createMesh();
	}

	function animate() {
		now = Date.now() - start;
		update();
		render();
		requestAnimationFrame(animate);
	}

	function update() {
		var ox, oy, oz, l, light, v, vertex, offset = MESH.depth / 2;

		// Update Bounds
		FSS.Vector3.copy(LIGHT.bounds, center);
		FSS.Vector3.multiplyScalar(LIGHT.bounds, LIGHT.xyScalar);

		// Update Attractor
		FSS.Vector3.setZ(attractor, LIGHT.zOffset);

		// Overwrite the Attractor position
		if (LIGHT.autopilot) {
			ox = Math.sin(LIGHT.step[0] * now * LIGHT.speed);
			oy = Math.cos(LIGHT.step[1] * now * LIGHT.speed);
			FSS.Vector3.set(attractor,
				LIGHT.bounds[0] * ox,
				LIGHT.bounds[1] * oy,
				LIGHT.zOffset);
		}

		// Animate Lights
		for (l = scene.lights.length - 1; l >= 0; l--) {
			light = scene.lights[l];

			// Reset the z position of the light
			FSS.Vector3.setZ(light.position, LIGHT.zOffset);

			// Calculate the force Luke!
			var D = Math.clamp(FSS.Vector3.distanceSquared(light.position, attractor), LIGHT.minDistance, LIGHT.maxDistance);
			var F = LIGHT.gravity * light.mass / D;
			FSS.Vector3.subtractVectors(light.force, attractor, light.position);
			FSS.Vector3.normalise(light.force);
			FSS.Vector3.multiplyScalar(light.force, F);

			// Update the light position
			FSS.Vector3.set(light.acceleration);
			FSS.Vector3.add(light.acceleration, light.force);
			FSS.Vector3.add(light.velocity, light.acceleration);
			FSS.Vector3.multiplyScalar(light.velocity, LIGHT.dampening);
			FSS.Vector3.limit(light.velocity, LIGHT.minLimit, LIGHT.maxLimit);
			FSS.Vector3.add(light.position, light.velocity);
		}

		// Animate Vertices
		for (v = geometry.vertices.length - 1; v >= 0; v--) {
			vertex = geometry.vertices[v];
			ox = Math.sin(vertex.time + vertex.step[0] * now * MESH.speed);
			oy = Math.cos(vertex.time + vertex.step[1] * now * MESH.speed);
			oz = Math.sin(vertex.time + vertex.step[2] * now * MESH.speed);
			FSS.Vector3.set(vertex.position,
				MESH.xRange * geometry.segmentWidth * ox,
				MESH.yRange * geometry.sliceHeight * oy,
				MESH.zRange * offset * oz - offset);
			FSS.Vector3.add(vertex.position, vertex.anchor);
		}

		// Set the Geometry to dirty
		geometry.dirty = true;
	}

	function render() {
		renderer.render(scene);

		// Draw Lights
		if (LIGHT.draw) {
			var l, lx, ly, light;
			for (l = scene.lights.length - 1; l >= 0; l--) {
				light = scene.lights[l];
				lx = light.position[0];
				ly = light.position[1];
				switch (RENDER.renderer) {
					case CANVAS:
						renderer.context.lineWidth = 0.5;
						renderer.context.beginPath();
						renderer.context.arc(lx, ly, 10, 0, Math.PIM2);
						renderer.context.strokeStyle = light.ambientHex;
						renderer.context.stroke();
						renderer.context.beginPath();
						renderer.context.arc(lx, ly, 4, 0, Math.PIM2);
						renderer.context.fillStyle = light.diffuseHex;
						renderer.context.fill();
						break;
					case SVG:
						lx += renderer.halfWidth;
						ly = renderer.halfHeight - ly;
						light.core.setAttributeNS(null, 'fill', light.diffuseHex);
						light.core.setAttributeNS(null, 'cx', lx);
						light.core.setAttributeNS(null, 'cy', ly);
						renderer.element.appendChild(light.core);
						light.ring.setAttributeNS(null, 'stroke', light.ambientHex);
						light.ring.setAttributeNS(null, 'cx', lx);
						light.ring.setAttributeNS(null, 'cy', ly);
						renderer.element.appendChild(light.ring);
						break;
				}
			}
		}
	}

	function addEventListeners() {
		window.addEventListener('resize', onWindowResize);
		container.addEventListener('click', onMouseClick);
		container.addEventListener('mousemove', onMouseMove);
	}


	//------------------------------
	// Callbacks
	//------------------------------
	function onMouseClick(event) {
		FSS.Vector3.set(attractor, event.x, renderer.height - event.y);
		FSS.Vector3.subtract(attractor, center);
		LIGHT.autopilot = !LIGHT.autopilot;
		autopilotController.updateDisplay();
	}

	function onMouseMove(event) {
		FSS.Vector3.set(attractor, event.x, renderer.height - event.y);
		FSS.Vector3.subtract(attractor, center);
	}

	function onWindowResize(event) {
		resize(container.offsetWidth, container.offsetHeight);
		render();
	}



	// Let there be light!
	initialise();

})();
