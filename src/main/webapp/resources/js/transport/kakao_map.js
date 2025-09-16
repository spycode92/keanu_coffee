// 본사 주소
var headOffice = new kakao.maps.LatLng(35.096256307681, 129.04247384597);

function renderDispatchMap(containerId, stops) {
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: headOffice, // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    }; 

	// 지도 생성
	var map = new kakao.maps.Map(mapContainer, mapOption);
	
	// 주소-좌표 변환 객체 생성
	var geocoder = new kakao.maps.services.Geocoder();
	// 출발지는 무조건 본사에서 시작
	var coords = [headOffice];
	
	// 경유지 순서대로 정렬
	stops.sort((a, b) => a.deliverySequence - b.deliverySequence);
	
	stops.forEach((stop) => {
		geocoder.addressSearch(stop.address, function(result, status) {
			if (status === kakao.maps.services.Status.OK) {
				var coord = new kakao.maps.LatLng(result[0].y, result[0].x);
				
				coords.push(coord)
				
				// 마커 생성
				var marker = new kakao.maps.Marker({
					map: map,
					position: coord
				});
				
				var infowindow = new kakao.maps.InfoWindow({
					content: `<div style="width:180px;text-align:center;padding:6px 0;">${stop.franchiseName}</div>`
				})
				infowindow.open(map, marker);
				
				// 모든 경유지의 좌표 변환이 끝났을 때 선 생성
				if (coords.length === stops.length  +1) {
					drawPolyline(map, coords);
				}
			}
		});
	});
}

// 좌표 생성 함수
function drawPolyline(map, coords) {
	var polyline = new kakao.maps.Polyline({
		map: map,
		path: coords,
		strokeWeight: 4, // 선 두께
		strokeColor: '#FF0000' // 선 색상
	});
	
	// 지도 범위 자동 조정
	var bounds = new kakao.maps.LatLngBounds();
	coords.forEach(c => bounds.extend(c));
	map.setBounds(bounds);
}