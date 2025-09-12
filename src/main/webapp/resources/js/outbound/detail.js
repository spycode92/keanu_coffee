document.addEventListener("DOMContentLoaded", function() {
    document.getElementById("btnBack")?.addEventListener("click", function(e) {
        e.preventDefault();
        history.back();
    });
});