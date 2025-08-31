const MODIFY_REGION_URL = "/transport/region/edit";
const DELETE_REGION_URL = "/transport/region/delete";

// 구역 이름 수정
function editRegion(commonCodeIdx, commonCodeName) {
	const li = $(event.target).closest(".region-item");
	const input = li.find(".region-name");
	const newName = input.val();
	
	// stromg 타입을 number 타입으로 변환
	commonCodeIdx = parseInt(commonCodeIdx);
	
	Swal.fire({
		title: "구역 이름을 수정하시겠습니까?",
		showDenyButton: true,
		confirmButtonText: "수정",
	  	denyButtonText: "취소"
	}).then((result) => {
		if (result.isConfirmed) {
			$.ajax({
				url: MODIFY_REGION_URL,
				type: "POST",
				contentType: "application/json",
				data: JSON.stringify({commonCodeIdx: commonCodeIdx, commonCodeName: newName}),
				error: function() {
					Swal.fire({
						icon: "error",
						text: "다시 시도해주세요"
					});
				}
			});
			Swal.fire("구역 이름이 수정되었습니다.", "", "success");
		} else {
			input.val(commonCodeName);
		}
	});
}

// 구역 삭제
function deleteRegion(commonCodeIdx) {
  // string 타입을 number 타입으로 변환
	commonCodeIdx = parseInt(commonCodeIdx);

	Swal.fire({
	    title: "구역을 삭제하시겠습니까?",
	    showDenyButton: true,
	    confirmButtonText: "삭제",
	    denyButtonText: "취소"
	  }).then((result) => {
	      if (result.isConfirmed) {
		      $.ajax({
		        url: DELETE_REGION_URL,
		        type: "POST",
		        contentType: "application/json",
		        data: JSON.stringify({ commonCodeIdx: commonCodeIdx }),
		        success: function() {
		          Swal.fire("삭제되었습니다.", "", "success").then(() => {
		            location.reload();
		          });
		        },
		        error: function(xhr) {
		          Swal.fire({
		            icon: "error",
		            text: xhr.responseText
		          });
		        }
		      });
	    	}
	  });
}
