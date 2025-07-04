package util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Base64;

public class ImageBase64 {

    public static String toBase64(byte[] fileBytes) {
        if (fileBytes != null && fileBytes.length > 0) {
            return Base64.getEncoder().encodeToString(fileBytes);
        }
        return null;
    }

    public static String toDataURI(byte[] fileBytes, String mimeType) {
        String base64 = toBase64(fileBytes);
        if (base64 != null) {
            return "data:" + mimeType + ";base64," + base64;
        }
        return null;
    }

}
