package util;

import java.util.Base64;

/**
 * @author huakh
 */
public class ImageBase64 {

    // Trả chuỗi base64 hoặc null nếu ảnh không tồn tại
    public static String toBase64(byte[] imageBytes) {
        if (imageBytes != null && imageBytes.length > 0) {
            return Base64.getEncoder().encodeToString(imageBytes);
        }
        return null;
    }

    // Trả sẵn chuỗi data:image/... để dùng trong <img src="...">
    public static String toDataURI(byte[] imageBytes, String mimeType) {
        String base64 = toBase64(imageBytes);
        if (base64 != null) {
            return "data:" + mimeType + ";base64," + base64;
        }
        return null;
    }
}
