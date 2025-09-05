const DELETE_DONG_URL = "/transport/mapping/delete";
const DELETE_GROUP_URL = "/transport/mappingGroup/delete";
const ADMINSTRATIVE_REGIONS_URL = "/transport/administrativeRegions";
const MAPPING_URL = "/transport/mapping/add";
const MAPPING_REGION_URL = "/transport/mapping/region";


$(function() {
	let administrativeRegionList = [];
	
	const sidoSelect = $("#sidoSelect");
	const sigunguSelect = $("#sigunguSelect");
 	const dongSelect = $("#dongSelect");

	// 중복값 제거 후 다시 배열에 담음
	const unique = (array) => [...new Set(array)];
	
	// 행정구역 데이터 로드
	$.getJSON(ADMINSTRATIVE_REGIONS_URL, function(data) {
		administrativeRegionList = data;
		initSidoSelect();
	});
	
	// 시/도 초기화
	function initSidoSelect() {
	    const sidos = unique(administrativeRegionList.map((region) => region.sido));
	    sidos.forEach(sido => {
	      sidoSelect.append($("<option>", { value: sido, text: sido }));
	    });
	}
	
	// 시/도 선택 이벤트
	sidoSelect.on("change", function() {
		const selectedSido = $(this).val();
		
		sigunguSelect.empty().append('<option value="">-- 시/군/구 선택 --</option>');
    	dongSelect.empty().append('<option value="">-- 동/리 선택 --</option>');
		
		 if (!selectedSido) {
			return;
		}
		
		 const sigungus = unique( 
		 	administrativeRegionList
	        .filter((region) => region.sido === selectedSido)
	        .map((region) => region.sigungu)
    	);

	     sigungus.forEach(sigungu => {
	       sigunguSelect.append($("<option>", { value: sigungu, text: sigungu }));
	     });
	});
	
	// 시군구 선택 이벤트
	sigunguSelect.on("change", function() {
		const selectedSido = sidoSelect.val()
		const selectedSigungu = $(this).val();
		
		dongSelect.empty().append('<option value="">-- 동/리 선택 --</option>');
		
		 if (!selectedSigungu) {
			return;
		}
		
		const dongs = administrativeRegionList.filter(
			(region) => region.sido === selectedSido && region.sigungu  === selectedSigungu);
		
		dongs.forEach((dong) => {
			dongSelect.append($("<option>", { value: dong.bcode, text: dong.dong }));
		})
	});
	
	// 동 선택 이벤트
	dongSelect.on("change", function() {
		const selectDong = $(this).val();
		
		 if (!selectDong) {
			return;
		}
  	});
});

// 매핑 버튼 클릭 시
$("#addMappingBtn").on("click", function() {
	const requestData = {
		regionIdx: $("#regionSelect").val(),
		bcode: $("#dongSelect").val()
	};
	
	const regionIdx = $('#regionSelect').val();
	const regionName = $('#regionSelect option:selected').text();
	const sido = $('#sidoSelect').val();
	const sigungu = $('#sigunguSelect').val();
	const dong = $('#dongSelect').val(); 
	
	if (!regionIdx || !sido || !sigungu || !dong) {
		Swal.fire("선택필수", "모든 값을 선택하세요", "error");
		return;
	}
	const { token, header } = getCsrf();
	
	$.ajax({
		url : MAPPING_URL,
		type: "POST",
		contentType: "application/json; charset=UTF-8",
		data: JSON.stringify(requestData),
		beforeSend(xhr) {
     	    if (token && header) xhr.setRequestHeader(header, token);
        },
		success: function(res) {
			Swal.fire("추가완료", "구역 범위가 등록되었습니다.", "success").then(() => {
				location.reload();
			});
			
			$("#sidoSelect").find("option:first").prop('selected', true);
			$("#sigunguSelect").find("option:first").prop('selected', true);
			$("#dongSelect").find("option:first").prop('selected', true);
			$("#regionSelect").find("option:first").prop('selected', true);

		},
		error: function(xhr) {
			Swal.fire("에러", xhr.responseText, "error");
		}
	});
});

// 구역별 지역 보여주기
$.ajax({
	  url: MAPPING_REGION_URL,
	  type: "GET",           
	  dataType: "json",
	  success: function(data) {
	    // 데이터 그룹핑
	    const grouped = data.reduce((acc, item) => {
		
		// 그룹핑 기준이 되는 키 생성
	    const key = `${item.commonCode}|${item.sido}|${item.sigungu}`;
		
		// 누적 데이터에 해당 키 그룹이 없을 경우 만들어줌 
	    if (!acc[key]) {
	      acc[key] = { ...item, dongs: [], idxList: [] };
	    }
	    acc[key].dongs.push(item.dong);
	    acc[key].idxList.push(item.regionAdministrativeMapIdx);
	    return acc;
	    }, {});
	
	    // 기존 테이블 내용 비우기
	    $("#mappingTable").empty();

		$.each(grouped, function(key, group) {
		  // dong들 각각 span + 삭제 버튼으로 변환
		  const dongHtml = group.dongs.map((dong, i) => `
		    <span class="dong-tag" data-idx="${group.idxList[i]}">
		      ${dong} <button class="dong-del">×</button></br>
		    </span>
		  `).join(" ");
		
		  $("#mappingTable").append(`
		    <tr>
		      <td>${group.commonCode}</td>
		      <td>${group.sido}</td>
		      <td>${group.sigungu}</td>
		      <td>${dongHtml}</td>
		      <td><button class="delete-btn" data-idx="${group.idxList.join(",")}">그룹삭제</button></td>
		    </tr>
		  `);
		});
	  },
	  error: function(xhr, status, error) {
	    console.error("에러 발생:", error);
	  }
});

// 매핑된 구역 삭제
$(document).on("click", ".dong-del", function() {
	let dongIdx = $(this).parent().data("idx");
	
	dongIdx = parseInt(dongIdx);
	
	Swal.fire({
		title: "이 동을 삭제하시겠습니까?",
		showDenyButton: true,
		confirmButtonText: "삭제",
	  	denyButtonText: "취소",
	}).then((result) => {
		if (result.isConfirmed) {
			const { token, header } = getCsrf();
			$.ajax({
				url: DELETE_DONG_URL,
				type: "POST",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify(dongIdx),
				beforeSend(xhr) {
			     	if (token && header) xhr.setRequestHeader(header, token);
			    },
				success: function() {
					Swal.fire("삭제완료", "", "success").then(() => {
						location.reload();
					});
				},
				error: function() {
					Swal.fire("다시 시도해주세요", "", "error");
				}
					
			});
		}
	});
});

// 그룹 삭제 버튼 클릭 시
$(document).on("click", ".delete-btn", function() {
	const stringIdxs = $(this).data("idx");
	const numIdxs =  String(stringIdxs).split(",").map(Number);
	
	Swal.fire({
		title: "이 그룹 전체를 삭제하시겠습니까?",
		showDenyButton: true,
		confirmButtonText: "배정",
	  	denyButtonText: "취소",
	}).then((result) => {
		if (result.isConfirmed) {
			const { token, header } = getCsrf();
			$.ajax({
				url: DELETE_GROUP_URL,
				type: "POST",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify(numIdxs),
			    beforeSend(xhr) {
			     	if (token && header) xhr.setRequestHeader(header, token);
			     },
				success: function() {
					Swal.fire("삭제완료", "", "success").then(() => {
						$(this).closest("tr").remove();
						location.reload();
					});
				},
				error: function() {
					Swal.fire("다시 시도해주세요", "", "error");
				}
			})
		}
	})
});
