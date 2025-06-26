<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div id="jsToast"
     class="toast align-items-center text-white bg-danger border-0 position-fixed bottom-0 end-0 m-3 d-none"
     role="alert">
    <div class="d-flex">
        <div class="toast-body" id="jsToastMessage"></div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
    </div>
</div>

<script>
    function showJsToast(message, type = 'danger') {
        const toastEl = document.getElementById('jsToast');
        const toastMsg = document.getElementById('jsToastMessage');

        toastMsg.innerHTML = message;

        toastEl.classList.remove('d-none', 'bg-danger', 'bg-success', 'bg-warning', 'bg-info');
        toastEl.classList.add('bg-' + type);

        const bsToast = new bootstrap.Toast(toastEl, { delay: 3000 });
        bsToast.show();
    }
</script>

<c:if test="${not empty err}">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            showJsToast("${fn:escapeXml(err)}", "danger");
        });
    </script>
</c:if>

<c:if test="${not empty success}">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            showJsToast("${fn:escapeXml(success)}", "success");
        });
    </script>
</c:if>