class Tweet {    
    
    // Твит
    Status stat;            
    
    // Текст твита
    String txt;             

    // Координаты
    float x, y; 
    
    // Время отображения
    int lifetime = 0;   
    
    // Ширина блока встплывающего текста
    int bubbleWidth = 200;
    
    // Отступ рамки от текста по осям x и y
    int marginX = 7;
    int marginY = 5;
    
    // Высота текст
    int h;

    // Флаг конца анимации
    boolean ended = false;

    // Конструктор объекта
    Tweet(Status s) {
        stat = s;
        txt = stat.getText();

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
        x = map((float)lon, (float)xmin, (float)xmax, 0, width);
        y = map((float)lat, (float)ymin, (float)ymax, height, 0);
        
        // Высчитываем высоту текстового блока
        h = calculateTextHeight(txt, bubbleWidth, 11, 12);
    }   

    // Функция обновления данных в твите.
    // По сути все ее действие сводится к вычислению прозрачности в данный момент
    void update() {
        // Увеличиваем время отображения на 1
        lifetime++;  
        
        // Выставляем флаг конца отображения
        if (lifetime >= 175) {
            ended = true;
        }
    }

    // Отрисовка твита
    void draw() {    
        
        // Задаем матрицу преобразования координат
        pushMatrix();
        
        // Смещаем координатную сетку
        translate(x,y);      
      
        // Рисуем синий кружок
        fill(0, 200, 255, 100);
        ellipse(0, 0, 12, 12); 
        
        // Рисуем желтую плашку
        fill(255, 255, 0, 255);      
        rect(0, 0, bubbleWidth + 2*marginX, h + 2*marginY);
        
        // Пишем текст твита
        fill(0, 255);
        textSize(11);
        textLeading(12);
        text(txt, marginX, marginY, bubbleWidth, h);         
        
        // Убираем матрицу
        popMatrix();
    }

    // После того как твит исчез рисуем синий кружок на карте
    void draw(PGraphics bg) {
        bg.beginDraw();
        bg.noStroke();        
        bg.fill(0, 200, 255, 100);
        bg.ellipse(x, y, 12, 12);
        bg.endDraw();
    }

    // Функция расчета высоты текстового блока
    int calculateTextHeight(String string, int specificWidth, int fontSize, int lineSpacing) {
        String[] wordsArray;
        String tempString = "";
        int numLines = 0;
        float textHeight;

        wordsArray = split(string, " ");
        textSize(fontSize);
        textLeading(lineSpacing);

        for (int i=0; i < wordsArray.length; i++) {
            if (textWidth(tempString + wordsArray[i]) < specificWidth) {
                tempString += wordsArray[i] + " ";
            }
            else {
                tempString = wordsArray[i] + " ";
                numLines++;
            }
        }

        numLines++;

        textHeight = numLines * (textDescent() + textAscent());
        return(round(textHeight));
    }
}

