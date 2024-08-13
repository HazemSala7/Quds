package quds.accounting.sala7

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import android.os.Handler
import android.os.Looper

class AuthActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Simulate biometric authentication
        Handler(Looper.getMainLooper()).postDelayed({
            // Create an Intent to return the result back to the calling Activity
            val resultIntent = Intent()
            resultIntent.putExtra("auth_result", "Authorized") // Use "Not Authorized" if failed
            setResult(RESULT_OK, resultIntent)
            finish() // Finish the AuthActivity and return to the previous screen
        }, 2000) // Simulate a delay for authentication
    }
}
