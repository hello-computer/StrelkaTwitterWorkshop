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

// Мин и макс широта и долгота на карте
double xmin = 37.1374, xmax = 38.1125, ymin = 55.5, ymax = 55.95;

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
    // Создаем соединение с Твиттером
    connectTwitter();

    // Добавляем обработчик данных от Твиттера
    twitter.addListener(listener);

    // Фильтр запроса  
    twitter.filter(new FilterQuery().locations(loc)); 
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
        
        // Пришел твит
        println("@" + status.getUser().getScreenName() + " - " + status.getText());
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

