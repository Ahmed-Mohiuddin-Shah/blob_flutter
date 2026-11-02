package com.blob.app

import android.app.Application
import sh.measure.android.Measure
import sh.measure.android.config.MeasureConfig

class BlobApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // API_URL + API_KEY come from AndroidManifest meta-data (self-hosted).
        Measure.init(this, MeasureConfig(enableLogging = true))
    }
}
