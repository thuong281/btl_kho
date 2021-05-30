String openingHours = "Giờ mở cửa";
String smokingText = "Có cho hút thuốc";
String levelText = "Số tầng";
String internetText = "Kết nối mạng";
String starsText = "Số sao";
String lanesText = "Số làn";
String maxSpeed = "Tốc độ tối đa";
String oneWayText = "Đường một chiều";
String twoWaysText = "Đường hai chiều";
String ratingInfo = "Xếp hạng và đánh giá";
String developing = 'Chức năng đang phát triển';
String describeExpInfo = "Mô tả trải nghiệm của bạn";
String noValueInfo = "";
String directionBtn = "Chỉ đường";
String shareBtn = "Chia sẻ";
String callBtn = "Gọi";
Map<String, String> categoryPlace = {
  "restaurant": "Nhà hàng",
  "cafe": "Quán cà phê",
  "fuel": "Cây xăng",
  "school": "Trường học",
  "hotel": "Khách sạn",
  "pharmacy": "Hiệu thuốc",
  "bar": "Quán bar",
  "busStop": "Trạm xe buýt",
  "hospital": "Bệnh viện",
  "university": "Trường đại học",
  "bank": "Ngân hàng",
  "fountain": "Đài phun nước",
  "cosmetics": "Cửa hàng mỹ phẩm",
  "residential": "Khu dân cư",
  "swimmingPool": "Bể bơi",
  "pub": "Quán rượu",
  "station": "Nhà ga",
  "market": "Chợ",
  "library": "Thư viện",
  "florist": "Cửa hàng hoa",
  "house": "Căn hộ",
  "government": "Cơ quan Nhà nước",
  "atm": "Cây ATM",
  "company": "Công ty",
  "departmentStore": "Cửa hàng bách hoá",
  "convenience": "Cửa hàng tiện lợi",
  "fashion": "Thời trang",
};

///Search SDK
const String wemap_yourLocation = "Vị trí của bạn";
const String wemap_chooseOnMap = "Chọn trên bản đồ";
const String wemap_searchHere = "Tìm kiếm ở đây";
const String wemap_searchHistory = 'LỊCH SỬ TÌM KIẾM';
const String wemap_today = 'HÔM NAY';
const String wemap_yesterday = 'HÔM QUA';
const String wemap_beforeYesterday = 'HÔM KIA';
const String wemap_previousSearches = 'CÁC TÌM KIẾM TRƯỚC';
const String wemap_moreHistory = 'Xem thêm lịch sử tìm kiếm';
const String wemap_searchNow = "Tìm kiếm ngay";
const String wemap_searchRecommend =
    "Hãy tìm kiếm một địa danh, địa điểm mà bạn quan tâm";
const String wemap_deleteAll = 'XOÁ TẤT CẢ';
const String wemap_notConnection = "Không có kết nối mạng";

///Explore, Weather, AQI SDK
//Explore
const String wemap_exploreAQIAddress =
    'Thời tiết và mức độ ô nhiễm không khí quanh khu vực';
const String wemap_exploreAround = "Khám phá xung quanh";
//AQI
const String wemap_aqiGood = 'Tốt';
const String wemap_aqiMorderate = 'Trung bình';
const String wemap_aqiUnhealthySensitive = 'Khá cao';
const String wemap_aqiUnhealthy = 'Cao';
const String wemap_aqiVeryUnhealthy = 'Rất cao';
const String wemap_aqiHazardous = 'Nguy hại';
const int wemap_kmRangeAQI = 10000;
const String wemap_aqiStation = 'Trạm đo chất lượng không khí gần nhất: ';
const String wemap_airnetLabel = 'Dữ liệu AQI được tổng hợp bởi: ';
const String wemap_pm25ValueLabel = 'Chỉ số bụi siêu mịn PM2.5: ';
const String wemap_pm10ValueLabel = 'Chỉ số bụi mịn PM10: ';
const String wemap_coValueLabel = 'Chỉ số khí CO: ';
const String wemap_aqiValueLabel = 'Chỉ số AQI: ';
String airnet([String kit]) =>
    kit == null ? 'https://airnet.vn/' : 'https://airnet.vn/kit/$kit';
//Weather
const String wemap_temperatureText = 'Nhiệt độ';
const String wemap_humidityText = 'Độ ẩm';
const String wemap_lastUpdated = 'Cập nhật lúc:';
const String wemap_sunrise = 'MT mọc: ';
const String wemap_sunset = 'MT lặn: ';
const String wemap_pressure = 'Áp suất: ';
const String wemap_windSpeed = 'Sức gió: ';
const String wemap_noData = 'Không có dữ liệu cập nhật';
String titleChart(String type) =>
    'Biểu đồ dữ liệu $type theo giờ trong 24 giờ gần nhất';
String weather([String id]) =>
    id == null ? 'openweathermap.org' : 'https://openweathermap.org/city/$id';
const Map<int, String> wemap_weatherDescription = {
  200: "Giông bão kèm mưa nhỏ",
  201: "Giông và có mưa",
  202: "Giông bão kèm mưa lớn",
  210: "Giông bão",
  211: "Giông",
  212: "Giông bão",
  221: "Giông bão",
  230: "Giông bão kèm mưa phùn nhẹ",
  231: "Giông bão kèm theo mưa phùn",
  232: "Giông bão kèm mưa phùn nặng hạt",
  300: "Mưa phùn nhẹ",
  301: "Mưa phùn",
  302: "Mưa phùn nặng hạt",
  310: "Mưa phùn nhẹ",
  311: "Mưa phùn",
  312: "Mưa phùn nặng hạt",
  313: "Mưa phùn",
  314: "Mưa lớn",
  321: "Mưa phùn",
  500: "Mưa nhỏ",
  501: "Mưa vừa",
  502: "Mưa lớn",
  503: "Mưa nặng hạt",
  504: "Mưa rất lớn",
  511: "Mưa lạnh",
  520: "Mưa rào",
  521: "Mưa rào",
  522: "Mưa lớn nặng hạt",
  531: "Mưa rào nặng hạt",
  600: "Tuyết nhẹ",
  601: "Tuyết",
  602: "Tuyết rơi nhiều",
  611: "Mưa đá",
  612: "Mưa tuyết nhẹ",
  613: "Mưa tuyết",
  615: "Mưa nhẹ kèm tuyết",
  616: "Mưa kèm tuyết",
  620: "Mưa tuyết nhẹ",
  621: "Mưa tuyết",
  622: "Mưa tuyết lớn",
  701: "Sương mù nhẹ",
  711: "Bụi",
  721: "Sương mù",
  731: "Xoáy cát / bụi",
  741: "Sương mù",
  751: "Cát",
  761: "Bụi bặm",
  762: "Bụi bặm cao",
  771: "Cơn gió mạnh",
  781: "Vòi rồng",
  800: "Bầu trời quang đãng",
  801: "Ít mây",
  802: "Trời âm u",
  803: "Nhiều mây",
  804: "Trời nhiều mây",
};

String hourText = "giờ";
String minuteText = "phút";
String secondText = "giây";
String hintInput = "Tìm kiếm";
const String routeShareText = "Lưu tuyến đường";
String kmText = "km";
String mText = "m";

String turnRightOnTurnRight = "Rẽ phải theo rẽ phải";
String turnLeftOnTurnLeft = "Rẽ trái theo rẽ trái";
String sharpRightOnSharpRight = "Rẽ phải ngay theo rẽ phải ngay";
String sharpLeftOnSharpLeft = "Rẽ trái ngay theo rẽ trái ngay";
String slightRightOnSlightRight = "Rẽ phải nhẹ theo rẽ phải nhẹ";
String slightLeftOnSlightLeft = "Rẽ trái nhẹ theo rẽ trái nhẹ";
String makeUTurnTo = "Quay đầu xe vào";
String makeUTurn = "Quay đầu xe";
String turnRightTo = "Rẽ phải vào ";
String turnLeftTo = "Rẽ trái vào ";
String sharpRightTo = "Rẽ phải ngay vào ";
String sharpLeftTo = "Rẽ trái ngay vào ";
String slightRightTo = "Rẽ phải nhẹ vào ";
String slightLeftTo = "Rẽ trái nhẹ vào ";
String turnRightOn = "Rẽ phải theo ";
String turnLeftOn = "Rẽ trái theo ";
String goToRight = "Đi theo hướng bên phải";
String goToLeft = "Đi theo hướng bên trái";

String meterText = " mét";
String meterThenText = " mét rồi ";
String kilometerText = " ki lô mét";
String kilometerThenText = " ki lô mét rồi ";
String continueText = " đi tiếp ";
String preview = "Xem trước";
String start = "Bắt đầu";
String originHint = "Điểm đi";
String originHintText = "Chọn điểm đi";
String destinationHint = "Điểm đến";
String destinationHintText = "Chọn điểm đến";
String chooseText = "Chọn";


