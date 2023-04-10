package com.miyou.pet_charity;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import android.view.Window;
import android.view.WindowManager;

import androidx.annotation.NonNull;

public class DisableScreenshots implements MethodChannel.MethodCallHandler {
    private static final String CHANNEL = "com.miyou.pet_charity/disableScreenshots";

    private final Window window;


    public DisableScreenshots(BinaryMessenger messenger, Window window) {
        MethodChannel channel = new MethodChannel(messenger, CHANNEL);
        channel.setMethodCallHandler(this);
        this.window = window;
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals("disableScreenshots")) {
            Boolean disable = call.argument("disable");
            if (disable != null) {
                result.success(setDisableScreenshotsStatus(disable));
            } else {
                result.success("");
            }
        }
    }

    private String setDisableScreenshotsStatus(boolean disable) {
        if (disable) {
            // 禁用截屏
            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE);
            return "set success";
        } else {
            // 允许截屏
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
            return "clear success";
        }
    }
}
