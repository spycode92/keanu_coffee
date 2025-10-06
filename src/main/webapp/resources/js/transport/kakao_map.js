// 본사 주소
var headOffice = new kakao.maps.LatLng(35.1584163, 129.0620714);

function renderDispatchMap(containerId, stops) {
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: headOffice, // 지도의 중심좌표
        level: 2 // 지도의 확대 레벨
    }; 

	// 지도 생성
	var map = new kakao.maps.Map(mapContainer, mapOption);
	
	// 주소-좌표 변환 객체 생성
	var geocoder = new kakao.maps.services.Geocoder();
	// 출발지는 무조건 본사에서 시작
	var coords = [headOffice];
	
    var startMarker = new kakao.maps.Marker({
        map: map,
        position: headOffice
    });

    var startInfo = new kakao.maps.InfoWindow({
        content: `<div style="
					  width: 150px; 
					  text-align: center;
					  padding: 6px 0; 
					  font-size: 0.6rem; 
					  color: #000;"
					>
					본사
					</div>`
    });
    startInfo.open(map, startMarker);

	// 경유지 순서대로 정렬
	stops.sort((a, b) => a.deliverySequence - b.deliverySequence);
	
	// 비동기 주소 변환을 Promise로 처리
	const promises = stops.map((stop) => {
		return new Promise((resolve) => {
	    	geocoder.addressSearch(stop.address, (result, status) => {
	        	if (status === kakao.maps.services.Status.OK) {
	          		const coord = new kakao.maps.LatLng(result[0].y, result[0].x);
	          		coords.push(coord);
	
		            // 각 지점 마커 표시
		            const marker = new kakao.maps.Marker({ map, position: coord });
		            const info = new kakao.maps.InfoWindow({
		              content: `<div style="
									width:150px;
									text-align:center;
									padding:6px 0; 
									font-size:0.6rem; 
									color:#000; 
								">
									${stop.franchiseName}
								</div>`
		            });
		            info.open(map, marker);
		
		            resolve(coord);
		          } else {
		            resolve(null);
		          }
	      	  });
	      });
	  });

	  // 모든 주소 변환이 끝난 후 실행
	  Promise.all(promises).then(() => {
	      const coordData = coords.map((c) => ({
	          x: c.getLng(),
	          y: c.getLat()
	  }));

	  // 서버에 도로 기반 경로 요청
	      $.ajax({
	        url: "/transport/dispatch/kakaoRoute",
	        type: "POST",
	        contentType: "application/json; charset=UTF-8",
	        data: JSON.stringify(coordData),
	        beforeSend(xhr) {
	          if (token && header) xhr.setRequestHeader(header, token);
	        },
	        success: function (res) {
				const route = res.routes[0];
				const summary = route.summary;
				
				// 거리(m)를 km로 변환
				const distanceKm = (summary.distance  / 1000).toFixed(2);
				
				// 시간(초)를 시, 분 단위로 변환
				const totalSeconds = summary.duration;
				const hours = Math.floor(totalSeconds / 3600);
				const minutes = Math.floor((totalSeconds % 3600) / 60);
				
	            // path 생성
	            const path = [];
	            route.sections.forEach((section) => {
	              section.roads.forEach((road) => {
	                for (let i = 0; i < road.vertexes.length; i += 2) {
	                  const x = road.vertexes[i];
	                  const y = road.vertexes[i + 1];
	                  path.push(new kakao.maps.LatLng(y, x));
	                }
	              });
	            });
	
	            // 도로 기반 Polyline 표시
	            const polyline = new kakao.maps.Polyline({
	              map,
	              path,
	              strokeWeight: 4,
	              strokeColor: "#FF0000",
	              strokeOpacity: 0.8,
	              strokeStyle: "solid"
	            });

				const message = `총 거리: ${distanceKm}km, 예상 시간: ${hours > 0 ? hours + "시간 " : ""}${minutes}분`;
				
				const overlayContent = `
					<div style="
				    	background: white;
				    	border: 1px solid #888;
				    	border-radius: 8px;
				    	padding: 8px 12px;
				    	font-size: 0.6rem;
						color:#000;
				    	box-shadow: 0 2px 5px rgba(0,0,0,0.2);
				    	white-space: nowrap;
				 	">
				    	${message}
				    </div>
				`;
				
				// 경로 상에 걸리는 시간 표시
				if (path.length > 0) {
				  const middleIndex = Math.floor(path.length / 3);
				  const midPosition = path[middleIndex];
				
				  const customOverlay = new kakao.maps.CustomOverlay({
				    position: midPosition, // 시간 표시 좌표
				    content: overlayContent,
				    yAnchor: 1.0
				  });
				
				  customOverlay.setMap(map);
				}
	
	            // 지도 범위 자동 조정
	            const bounds = new kakao.maps.LatLngBounds();
	            path.forEach((p) => bounds.extend(p));
	            map.setBounds(bounds);
	          },
	          error: function (error) {
	              console.error("경로 요청 실패:", error);
	          }
	       });
	    });
}