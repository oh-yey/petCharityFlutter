package com.miyou.pet_charity;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

import androidx.annotation.NonNull;


public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new DisableScreenshots(flutterEngine.getDartExecutor().getBinaryMessenger(), getWindow());
    }

}
