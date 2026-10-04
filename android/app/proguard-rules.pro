# ML Kit 텍스트 인식 플러그인은 데바나가리 모델도 참조하지만 이 앱은 넣지 않는다.
-dontwarn com.google.mlkit.vision.text.devanagari.**

# 출시용 빌드(R8)가 ML Kit 내부 클래스를 줄이거나 이름을 바꾸면 영수증 인식이
# NullPointerException 으로 실패한다 (InputImage 생성 중 ML Kit 내부 로깅 클래스).
# ML Kit 은 내부에서 리플렉션을 쓰므로 통째로 남긴다.
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_** { *; }
-keep class com.google.android.odml.** { *; }
-keep class com.google_mlkit_commons.** { *; }
-keep class com.google_mlkit_text_recognition.** { *; }
