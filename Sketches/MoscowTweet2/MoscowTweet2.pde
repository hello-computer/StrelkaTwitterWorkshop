/*

 Tweet Moscow by Max Yahontov
 http://fusionlab.ru
 
 Есть вопросы:
 maxyahontov@yandex.ru
 
 */


// Ключи приложения
// Нужно создать свое приложение и получить для него ключи по адресу: https://dev.twitter.com/apps/new
static String OAuthConsumerKey = "js5oCEMOwE1pUFuO0LFQ";
static String OAuthConsumerSecret = "uokSMbjf9T6YGDnc9BYLYwLHJfiHm8HFfn0V9DiM";

// Токены доступа
// Можно получить на странице настроек созданного приложения
static String AccessToken = "206371072-0lgqQkEQClbipR3V3t0sbsZFSQ8rxeWC60g4uKWE";
static String AccessTokenSecret = "DOikZ6l7ezPe7ecDzDvsDNlrymv0XJXjvKt0XtkPw";

// Создаем бъект для работы с потоком сообщений из твиттера
TwitterStream twitter = new TwitterStreamFactory().getInstance();

// Карта
PImage mosmap;

// Мин и макс широта и долгота на карте
double xmin = 37.1374, xmax = 38.1125, ymin = 55.5, ymax = 55.95;

// Координаты центра Москвы
double xmos = 37.609218, ymos = 55.753559;

// Массив, с координатами для запроса
double[][] loc = {
    {
        xmin, ymin
    }
    , 
    {
        xmax, ymax
    }
};

void setup() {
    // Базовые настройки приложения   
    size(709, 583);

    // Отключаем обводку и включаем сглаживание
    noStroke();
    smooth();

    // Создаем соединение с Твиттером
    connectTwitter();

    // Добавляем обработчик данных от Твиттера
    twitter.addListener(listener);

    // Фильтр запроса  
    twitter.filter(new FilterQuery().locations(loc)); 

    // Загружаем изображение с картой и рисуем его
    mosmap = loadImage("mosmap.png");
    image(mosmap, 0, 0);
}

// Функция соединения с Твиттером
void connectTwitter() {
    // Задаем ключи авторизации
    twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);     

    // Получаем токен для доступа
    twitter.setOAuthAccessToken(new AccessToken(AccessToken, AccessTokenSecret));
}

// Функция для отрисовки твита
void showTweet(Status s) {
    // Получаем геоданные
    GeoLocation geo = s.getGeoLocation();
    double lon, lat;

    if (geo != null) {            
        lon = geo.getLongitude();
        lat = geo.getLatitude();
    }
    // У некоторых твитов нет координат
    // Будем отображать их в самом центре Москвы
    else {           
        lon = xmos;
        lat = ymos;
    } 

    // Переводим широту и долготу в координаты на карте Москвы
    float x = map((float)lon, (float)xmin, (float)xmax, 0, width);
    float y = map((float)lat, (float)ymin, (float)ymax, height, 0);
    
    // Рисуем синий кружок
    fill(0, 200, 255, 100);
    ellipse(x, y, 12, 12); 
}

void draw() {
}


// Создаем объект, который обрабатывает все получаемые данные
StatusListener listener = new StatusListener() {

    // Обработчик, который вызывается автоматически при получении нового твита
    public void onStatus(Status status) {

        // Рисуем твит на карте
        showTweet(status);
    }

    // Обработчики ошибок и нестандартных ситуаций (не используются в приложении)
    public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    }
    public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    }
    public void onScrubGeo(long userId, long upToStatusId) {
    }
    public void onException(Exception ex) {
        ex.printStackTrace();
    }
};

