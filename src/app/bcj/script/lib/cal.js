//(MLonA, MLatA)和(MLonB, MLatB)
// C = sin(LatA*Pi/180)*sin(LatB*Pi/180) + cos(LatA*Pi/180)*cos(LatB*Pi/180)*cos((MLonA-MLonB)*Pi/180)
//
// Distance = R*Arccos(C)*Pi/180
//http://blog.csdn.net/yl2isoft/article/details/16367901

//计算2个经纬度之间的距离 Longitude:经度 Latitude:纬度 (单位: 米) 
define(function(){
    return function calDistance(targetLongitude, targetLatitude, currentLongitude, currentLatitude){
        var EARTH_RADIUS =  6371*1000 //地球平均半径为6371*1000米
        var radius = function(d){
         return d * Math.PI / 180.0;
        }
        var radTargetLatitude = radius(targetLatitude);
        var radCurrentLatitude = radius(currentLatitude);
        var a = radTargetLatitude - radCurrentLatitude;
        var b = radius(targetLongitude) - radius(currentLongitude);
        var distance = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a/2),2) +
            Math.cos(radTargetLatitude)*Math.cos(radCurrentLatitude)*Math.pow(Math.sin(b/2),2)));
        distance = distance * EARTH_RADIUS;
        return Math.round(distance * 10000) / 10000;
    }
})
