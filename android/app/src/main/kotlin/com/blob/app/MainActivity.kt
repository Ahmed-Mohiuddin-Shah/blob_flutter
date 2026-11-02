package com.blob.app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // OAuth custom-scheme must not become a Flutter / go_router route.
        stripOAuthDeepLink(intent)
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        stripOAuthDeepLink(intent)
        super.onNewIntent(intent)
    }

    private fun stripOAuthDeepLink(intent: Intent?) {
        val data = intent?.data ?: return
        val scheme = data.scheme ?: return
        val isOAuth = scheme.startsWith("com.mamajees.blob.app") ||
            data.path == "/oauthredirect" ||
            data.toString().contains("oauthredirect")
        if (isOAuth) {
            intent.data = null
        }
    }
}
