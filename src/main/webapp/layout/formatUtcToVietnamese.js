function formatUtcToVietnamese(selector) {
    const timeZone = "Asia/Ho_Chi_Minh";

    document.querySelectorAll(selector).forEach(el => {
        const raw = el.dataset.utc;

        if (raw) {
            const rawUtc = raw.endsWith("Z") ? raw : raw + "Z";
            const utcDate = new Date(rawUtc);

            const vnDate = new Date(utcDate.toLocaleString("en-US", { timeZone }));

            const hours = String(vnDate.getHours()).padStart(2, '0');
            const minutes = String(vnDate.getMinutes()).padStart(2, '0');
            const day = String(vnDate.getDate()).padStart(2, '0');
            const month = String(vnDate.getMonth() + 1).padStart(2, '0');
            const year = vnDate.getFullYear();

            el.textContent = `${hours}:${minutes} ${day}/${month}/${year}`;
        }
    });
}
