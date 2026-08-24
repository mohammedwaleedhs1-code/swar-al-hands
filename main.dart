import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text('نظام سوار الكف الذكي - أولي الألباب'),
          backgroundColor: Colors.black54,
          centerTitle: true,
        ),
        body: SmartWristbandDemo(),
      ),
    ));

class SmartWristbandDemo extends StatelessWidget {
  // 🔑 الخطوة الثامنة: دالة برمجية غير متزامنة تحاكي جلب بيانات السوار بالراديو بدون نت
  Future<Map<String, dynamic>> fetchSwarData() async {
    await Future.delayed(Duration(seconds: 4)); // محاكاة انتظار الإشارة لمدة 4 ثوانٍ
    return {
      "pulse": 52, // نبض واطئ جداً يمثل حالة إغماء
      "location": "قرب باب القبلة",
      "status": "🚨 تحذير: تم رصد حالة إغماء! إرسال نداء استغاثة فوري لمستشفيات العتبة الحسينية..."
    };
  }

  @override
  Widget build(BuildContext context) {
    // 🔑 الخطوة التاسعة: الـ FutureBuilder الذي يستقبل البيانات ويحدث الشاشة تلقائياً
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchSwarData(),
      builder: (context, snapshot) {
        // 1. مرحلة التحميل والانتظار (بينما السوار يفحص النبض)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.cyan, strokeWidth: 5),
                SizedBox(height: 20),
                Text(
                  "جاري فحص العلامات الحيوية والاتصال اللاسلكي...",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          );
        }
        // 2. في حال حدوث خطأ في المنظومة
        else if (snapshot.hasError) {
          return Center(
            child: Text('خطأ في استلام إشارة السوار اللاسلكية', style: TextStyle(color: Colors.red)),
          );
        }
        // 3. فور وصول البيانات (تحليل حالة الزائر وعرض التنبيه)
        else {
          var swarData = snapshot.data!;
          int pulse = swarData["pulse"];
          bool isDanger = (pulse < 60 || pulse > 120);

          return Container(
            color: isDanger ? Colors.red : Colors.green,
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isDanger ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                    size: 100,
                    color: Colors.white,
                  ),
                  SizedBox(height: 25),
                  Text(
                    'معدل نبض القلب الحالي: $pulse bpm',
                    style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'الموقع الجغرافي: ${swarData["location"]}',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  SizedBox(height: 30),
                  Card(
                    color: Colors.white12,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        '${swarData["status"]}',
                        textAlign: Center,
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
