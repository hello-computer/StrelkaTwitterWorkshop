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

// Массив, в котором будут сохранятся твиты
ArrayList tweets = new ArrayList();

// Карта
PImage mosmap;

// Фоновое изоражения
PGraphics bg;

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

    // Загружаем изображение с картой
    mosmap = loadImage("mosmap.png");

    // Создаем пустое фоновое изображение, на нем будет рисоваться карта и точки, анимация которых окончена (для экономии памяти)
    bg = createGraphics(width, height, P2D);

    // Переносим карту на фоновое изображение
    bg.beginDraw();
    bg.image(mosmap, 0, 0);
    bg.endDraw();
}

void draw() {

    // проходимся по массиву всех твитов, обновляем их. 
    // Если анимация твита закончена, удаляем его из массива и отрисовываем на фоновом изображении
    for (int i =0; i < tweets.size(); i++) {
        Tweet t = (Tweet)tweets.get(i);      
        t.update();      
        if (t.ended) {
            tweets.remove(i);
            t.draw(bg);
        }
    }     
   
    // Рисуем фоновую карту 
    image(bg, 0, 0); 
    
    // Отрисовываем поверх карты все твиты, которые сейччас анимируются
    for (int i =0; i < tweets.size(); i++) {
        Tweet t = (Tweet)tweets.get(i);
        t.draw();
    } 
}

// Функция соединения с Твиттером
void connectTwitter() {
    // Задаем ключи авторизации
    twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);     
    
    // Получаем токен для доступа
    twitter.setOAuthAccessToken(new AccessToken(AccessToken, AccessTokenSecret));
}

// Создаем объект, который обрабатывает все получаемые данные
StatusListener listener = new StatusListener() {
    
    // Обработчик, который вызывается автоматически при получении нового твита
    public void onStatus(Status status) {
        
        // Создаем новый объект сообщения и добавляем его в массив
        tweets.add(new Tweet(status));
    }

    // Обработчики ошибок и нестандартных ситуация (не используются в приложении)
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
