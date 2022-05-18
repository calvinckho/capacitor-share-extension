package com.capacitor.shareextension.plugin;

import android.os.Bundle;

import com.getcapacitor.BridgeActivity;

public class ShareExtensionActivity extends BridgeActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        registerPlugin(ShareExtension.class);
    }

    @Override
    public void onPause() {
        super.onPause();
        finish();
    }

    @Override
    public void onStop() {
        super.onStop();
        finish();
    }
}
