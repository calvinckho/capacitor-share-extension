package com.capacitor.shareextension.plugin;

import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.OpenableColumns;
import android.util.Log;

import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import com.getcapacitor.FileUtils;
import org.apache.commons.io.IOUtils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;


@CapacitorPlugin()
public class ShareExtension extends Plugin {

    @PluginMethod
    public void checkSendIntentReceived(PluginCall call) {
        Intent intent = bridge.getActivity().getIntent();
        String action = intent.getAction();
        String type = intent.getType();
        List payload = new ArrayList<JSObject>();
        JSObject ret = new JSObject();
        //Log.v("SHARE", "Intent received, " + type);
        if (Intent.ACTION_SEND.equals(action) && type != null) {
            payload.add(readItemAt(intent, type, 0));
            ret.put("payload", new JSArray(payload));
            call.resolve(ret);
        } else if (Intent.ACTION_SEND_MULTIPLE.equals(action) && type != null) {
            for (int index = 0; index < intent.getClipData().getItemCount(); index++) {
                payload.add(readItemAt(intent, type, index));
            }
            ret.put("payload", new JSArray(payload));
            call.resolve(ret);
        } else {
            call.reject("No processing needed");
        }
    }

    @PluginMethod
    public void finish(PluginCall call) {
        bridge.getActivity().finish();

        JSObject ret = new JSObject();
        ret.put("success", true);
        call.resolve(ret);
    }

    private JSObject readItemAt(Intent intent, String type, int index) {
        JSObject ret = new JSObject();
        String title = intent.getStringExtra(Intent.EXTRA_SUBJECT);
        Uri uri = null;

        if (intent.getClipData() != null && intent.getClipData().getItemAt(index) != null)
            uri = intent.getClipData().getItemAt(index).getUri();

        String url = null;
        Uri copyfileUri = null;
        //Handling web links as url
        if ("text/plain".equals(type) && intent.getStringExtra(Intent.EXTRA_TEXT) != null) {
            url = intent.getStringExtra(Intent.EXTRA_TEXT);
        }
        //Handling files as url
        else if (uri != null) {
            copyfileUri = copyfile(uri);
            url = (copyfileUri != null) ? copyfileUri.toString() : null;
        }

        if (title == null && uri != null)
            title = readFileName(uri);

        String webPath = "";
        if (!("text/plain".equals(type))) {
            webPath = FileUtils.getPortablePath(getContext(), bridge.getLocalUrl(), copyfileUri);
        }

        ret.put("title", title);
        ret.put("description", null);
        ret.put("type", type);
        ret.put("url", url);
        ret.put("webPath", webPath);
        return ret;
    }

    public String readFileName(Uri uri) {
        Cursor returnCursor =
                getContext().getContentResolver().query(uri, null, null, null, null);
        /*
         * Get the column indexes of the data in the Cursor,
         * move to the first row in the Cursor, get the data,
         * and display it.
         */
        returnCursor.moveToFirst();
        return returnCursor.getString(returnCursor.getColumnIndex(OpenableColumns.DISPLAY_NAME));
    }

    Uri copyfile(Uri uri) {
        final String fileName = readFileName(uri);
        File file = new File(getContext().getFilesDir(), fileName);

        try (FileOutputStream outputStream = getContext().openFileOutput(fileName, Context.MODE_PRIVATE);
             InputStream inputStream = getContext().getContentResolver().openInputStream(uri)) {
            IOUtils.copy(inputStream, outputStream);
            return Uri.fromFile(file);
        } catch (FileNotFoundException fileNotFoundException) {
            fileNotFoundException.printStackTrace();
        } catch (IOException ioException) {
            ioException.printStackTrace();
        }
        return null;
    }
}
