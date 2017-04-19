// Обработка предназначена для автоматизированного расчета цикломатической сложности кода
// Адрес публикации на Инфорстарте: http://infostart.ru/public/166182/
// Вы можете использовать обработку по своему усмотрению в рамках действующего законодательства.
// Единственная просьба: если у вас есть замечания или предложения по улучшению обработки, а также в случае нахождения багов - пишите мне об этом на http://infostart.ru/profile/101097/

#Использовать cmdline
#Использовать logos

Перем МассивСтрокМодуля Экспорт;
Перем ДеревоРезультатовАнализа;
Перем ТекстМодуля;
Перем Лог;

// функция ищет следующее, после указанного символа, вхождение подстроки
//
// Параметры
//  Строка  – Строка – строка, в которой нужно искать
//  Подстрока  – Строка – строка, которую нужно найти
//	НачинатьС - Число - номер символа, с которого нужно начинать поиск
//				(если не указан, начинает с начала)
//
// Возвращаемое значение:
//   Число   – номер символа, с которого начинается (очередное) вхождения подстроки в строку
//
Функция НайтиСледующееВхождениеПодстроки(Знач Строка, Знач Подстрока, НачинатьС = 1) Экспорт
	Результат = Найти(Сред(ВРег(Строка), НачинатьС), ВРег(Подстрока));
	Если Результат <> 0 Тогда
		Результат = Результат + НачинатьС - 1;
	КонецЕсли;

	Возврат Результат;
КонецФункции

// функция ищет предыдущее, перед указанным символом, вхождение подстроки
//
// Параметры
//  Строка  – Строка – строка, в которой нужно искать
//  Подстрока  – Строка – строка, которую нужно найти
//	НачинатьС - Число - номер символа, с которого нужно начинать поиск
//			(если не указан, начинает с конца)
//
// Возвращаемое значение:
//   Число   – номер символа, с которого начинается (предыдущее) вхождения подстроки в строку
//
Функция НайтиПредыдущееВхождениеПодстроки(Знач Строка, Знач Подстрока, Знач НачинатьС = 0) Экспорт
	Строка = ВРег(Строка);
	Подстрока = ВРег(Подстрока);

	ДлинаСтроки = СтрДлина(Строка);
	ДлинаПодстроки = СтрДлина(Подстрока);
	Если НачинатьС = 0 Тогда
		НачинатьС = ДлинаСтроки - ДлинаПодстроки + 1;
	КонецЕсли;

	Результат = 0;

	Пока НачинатьС > 0 И Результат = 0 Цикл
		// сравнивать напрямую нельзя - строки могут быть в разных регистрах
		Если Найти(Сред(Строка, НачинатьС, ДлинаПодстроки), Подстрока) = 1 Тогда
			// нашли вхождение подстроки
			Результат = НачинатьС;
		КонецЕсли;
		НачинатьС = НачинатьС - 1;
	КонецЦикла;

	Возврат Результат;
КонецФункции

// процедура выполняет удаление всех двойных кавычек в модуле
//
// Параметры
//  Текст  – Строка – текст анализируемого модуля
//
Процедура УбратьДвойныеКавычки(Текст) Экспорт
	Текст = СтрЗаменить(Текст, """""", "");
КонецПроцедуры

// процедура выполняет удаление всех комментариев модуля
//
// Параметры
//  Текст  – Строка – текст анализируемого модуля
//
Процедура УбратьКомментарии(Текст) Экспорт
	ПозицияНачалаКомментария = НайтиСледующееВхождениеПодстроки(Текст, "//");
	Пока ПозицияНачалаКомментария <> 0 Цикл
		//перед тем, как удалять нужно проверить, что эти слеши не находятся в строке
		НачалоТекущейСтроки = НайтиПредыдущееВхождениеПодстроки(Текст, Символы.ПС, ПозицияНачалаКомментария);
		Если НачалоТекущейСтроки = 0 Тогда
			НачалоТекущейСтроки = 1;
		КонецЕсли;

		ТекущаяСтрока = СокрЛ(Сред(Текст, НачалоТекущейСтроки, ПозицияНачалаКомментария - НачалоТекущейСтроки));
		КоличествоКавычек = СтрЧислоВхождений(ТекущаяСтрока, """");
		Если Лев(ТекущаяСтрока, 1) = "|" Тогда
			КоличествоКавычек = КоличествоКавычек + 1;
		КонецЕсли;

		Если КоличествоКавычек % 2 = 1 Тогда
			// найденные слэши находятся внутри строковой константы - это НЕ начало комментария, их можно просто удалить
			Текст = Лев(Текст, ПозицияНачалаКомментария - 1) + Сред(Текст, ПозицияНачалаКомментария + 2);
		Иначе
			// это начало комментария, текст после них до конца строки можно удалить
			НачалоСледующейСтроки = НайтиСледующееВхождениеПодстроки(Текст, Символы.ПС, ПозицияНачалаКомментария);
			Текст = Лев(Текст, ПозицияНачалаКомментария - 1) + ?(НачалоСледующейСтроки <> 0, Сред(Текст, НачалоСледующейСтроки), "");
		КонецЕсли;

		ПозицияНачалаКомментария = НайтиСледующееВхождениеПодстроки(Текст, "//");
	КонецЦикла;
КонецПроцедуры

// функция выполняет удаление всех строковых констант модуля
//
// Параметры
//  Текст  – Строка – текст анализируемого модуля
//
// Возвращаемое значение:
//   Число   – код возникшей ошибки:
//			1 - нечетное количество кавычек
//
Функция УбратьСтроковыеКонстанты(Текст) Экспорт
	Результат = 0;

	КоличествоКавычек = СтрЧислоВхождений(Текст, """");

	Если КоличествоКавычек % 2 = 1 Тогда
		Возврат 1;
	КонецЕсли;

	ПозицияНачалаСтроковойКонстанты = 1;
	Пока ПозицияНачалаСтроковойКонстанты <> 0 Цикл
		ПозицияНачалаСтроковойКонстанты = НайтиСледующееВхождениеПодстроки(Текст, """");
		ПозицияОкончанияСтроковойКонстанты = НайтиСледующееВхождениеПодстроки(Текст, """", ПозицияНачалаСтроковойКонстанты + 1);

		Текст = Лев(Текст, ПозицияНачалаСтроковойКонстанты - 1) + Сред(Текст, ПозицияОкончанияСтроковойКонстанты + 1);
	КонецЦикла;

	Возврат Результат;
КонецФункции

// процедура выполняет удаление всех комментариев модуля
//
// Параметры
//  Текст  – Строка – текст анализируемого модуля
//	Директива - Строка - идентификатор директивы (# или &)
//
Процедура УбратьДирективыКомпиляции(Текст, Директива) Экспорт
	ПозицияНачалаДирективы = НайтиСледующееВхождениеПодстроки(Текст, Директива);
	Пока ПозицияНачалаДирективы <> 0 Цикл
		НачалоТекущейСтроки = НайтиПредыдущееВхождениеПодстроки(Текст, Символы.ПС, ПозицияНачалаДирективы);
		Если НачалоТекущейСтроки = 0 Тогда
			НачалоТекущейСтроки = 1;
		КонецЕсли;

		СтрокаПередХешем = Сред(Текст, НачалоТекущейСтроки, ПозицияНачалаДирективы - НачалоТекущейСтроки);

		// директивы не могут стоять после других команд или текста в строке - перед ними могут быть только незначащие символы
		Если СокрЛП(СтрокаПередХешем) = "" Тогда
			НачалоСледующейСтроки = НайтиСледующееВхождениеПодстроки(Текст, Символы.ПС, ПозицияНачалаДирективы + 1);
			Если НачалоСледующейСтроки = 0 Тогда
				НачалоСледующейСтроки = СтрДлина(Текст);
			КонецЕсли;
			Текст = ?(НачалоТекущейСтроки > 1, Лев(Текст, НачалоТекущейСтроки), "") + Сред(Текст, НачалоСледующейСтроки);
		КонецЕсли;

		ПозицияНачалаДирективы = НайтиСледующееВхождениеПодстроки(Текст, Директива, ПозицияНачалаДирективы);
	КонецЦикла;
КонецПроцедуры

// функция выделяет из переданного текста текст следующего метода и возвращает его
//
// Параметры
//  Текст  – Строка – текст анализируемого модуля
//	ИмяМетода - Строка - функция возвращает имя найденного метода
//
// Возвращаемое значение:
//   Строка – текст очередного метода
//
Функция ИзвлечьСледующийМетод(Текст, ИмяМетода)
	Результат = "";
	ИмяМетода = "";
	КонецМетода = 0;

	Текст = СокрЛ(Текст);
	// анализируем следующий метод
	ПозицияСкобки = НайтиСледующееВхождениеПодстроки(Текст, "(");
	Если ПозицияСкобки <> 0 Тогда
		ЗаголовокМетода = Лев(Текст, ПозицияСкобки - 1);
		Текст = Сред(Текст, ПозицияСкобки);

		Если ВРег(Лев(ЗаголовокМетода, 9)) = ВРег("Процедура") ИЛИ
			 ВРег(Лев(ЗаголовокМетода, 9)) = ВРег("Procedure") Тогда

			ИмяМетода = СокрЛП(Сред(ЗаголовокМетода, 11));
			КонецМетодаРусс = НайтиСледующееВхождениеПодстроки(Текст, "КонецПроцедуры");
			КонецМетодаАнгл = НайтиСледующееВхождениеПодстроки(Текст, "EndProcedure");
			Если КонецМетодаРусс <> 0 Тогда
				Если КонецМетодаАнгл <> 0 Тогда
					Если КонецМетодаРусс < КонецМетодаАнгл Тогда
						КонецМетода = КонецМетодаРусс + 14; // 14 = СтрДлина("КонецПроцедуры")
					Иначе
						КонецМетода = КонецМетодаАнгл + 12; // 12 = СтрДлина("EndProcedure")
					КонецЕсли;
				Иначе
					КонецМетода = КонецМетодаРусс + 14; // 14 = СтрДлина("КонецПроцедуры")
				КонецЕсли;
			Иначе // КонецМетодаРусс = 0
				Если КонецМетодаАнгл <> 0 Тогда
					КонецМетода = КонецМетодаАнгл + 12; // 12 = СтрДлина("EndProcedure")
				Иначе
					ВызватьИсключение "Не удалось найти завершение процедуры " + ИмяМетода;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ВРег(Лев(ЗаголовокМетода, 7)) = ВРег("Функция") ИЛИ
			 	  ВРег(Лев(ЗаголовокМетода, 8)) = ВРег("Function") Тогда

			Если ВРег(Лев(ЗаголовокМетода, 7)) = ВРег("Функция") Тогда
				ИмяМетода = СокрЛП(Сред(ЗаголовокМетода, 8));
			Иначе
				ИмяМетода = СокрЛП(Сред(ЗаголовокМетода, 9));
			КонецЕсли;

			КонецМетодаРусс = НайтиСледующееВхождениеПодстроки(Текст, "КонецФункции");
			КонецМетодаАнгл = НайтиСледующееВхождениеПодстроки(Текст, "EndFunction");
			Если КонецМетодаРусс <> 0 Тогда
				Если КонецМетодаАнгл <> 0 Тогда
					Если КонецМетодаРусс < КонецМетодаАнгл Тогда
						КонецМетода = КонецМетодаРусс + 12; // 12 = СтрДлина("КонецФункции")
					Иначе
						КонецМетода = КонецМетодаАнгл + 11; // 11 = СтрДлина("EndFunction")
					КонецЕсли;
				Иначе
					КонецМетода = КонецМетодаРусс + 12; // 12 = СтрДлина("КонецФункции")
				КонецЕсли;
			Иначе // КонецМетодаРусс = 0
				Если КонецМетодаАнгл <> 0 Тогда
					КонецМетода = КонецМетодаАнгл + 11; // 11 = СтрДлина("EndFunction")
				Иначе
					ВызватьИсключение "Не удалось найти завершение функции " + ИмяМетода;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если КонецМетода <> 0 Тогда
		Результат = СокрЛП(Лев(Текст, КонецМетода));
		Текст = СокрЛП(Сред(Текст, КонецМетода + 1));
	Иначе
		ИмяМетода = "<Инициализация модуля>";
		Результат = СокрЛП(Текст);
		Текст = "";
	КонецЕсли;

	Возврат Результат;
КонецФункции

// функция ищет следующее вхождение Слова в Текст
//
// Параметры
//  Текст  – Строка – анализируемый текст
//  Слово  – Строка – искомое слово
//	НачинатьС - Число - откуда искать
//
// Возвращаемое значение:
//   Число   – начало следующего вхождения слова
//
Функция НайтиСледующееВхождениеСлова(Текст, Слово, Знач Курсор = 1)
	СловоНайдено = Ложь;
	ДлинаСлова = СтрДлина(Слово);
	Пока Курсор <> 0 И Не СловоНайдено Цикл
		Курсор =  НайтиСледующееВхождениеПодстроки(Текст, Слово, Курсор);
		//проверим, что это не часть идентификатора
		Если Курсор <> 0 Тогда
			КодСимволаСлева = КодСимвола(Текст, Курсор - 1);
			КодСимволаСправа = КодСимвола(Текст, Курсор + ДлинаСлова);
			Если НЕ (
				(КодСимволаСлева >= 97 И КодСимволаСлева <= 122) ИЛИ		// a-z
				(КодСимволаСлева >= 65 И КодСимволаСлева <= 90) ИЛИ			// A-Z
				(КодСимволаСлева >= 1040 И КодСимволаСлева <= 1103) ИЛИ		// А-Я,а-я
				(КодСимволаСлева >= 48 И КодСимволаСлева <= 57) ИЛИ			// 0-9
				(КодСимволаСлева = 95) ИЛИ	// "_"
				(КодСимволаСправа >= 97 И КодСимволаСправа <= 122) ИЛИ		// a-z
				(КодСимволаСправа >= 65 И КодСимволаСправа <= 90) ИЛИ		// A-Z
				(КодСимволаСправа >= 1040 И КодСимволаСправа <= 1103) ИЛИ	// А-Я,а-я
				(КодСимволаСправа >= 48 И КодСимволаСправа <= 57) ИЛИ		// 0-9
				(КодСимволаСправа = 95)	 // "_"
				) Тогда // это не часть идентификатора
				СловоНайдено = Истина;
			Иначе
				Курсор = Курсор + ДлинаСлова;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Курсор;
КонецФункции

// функция считает количество вхождений Слова в Текст
//
// Параметры
//  Текст  – Строка – анализируемый текст
//  Слово  – Строка – искомое слово
//
// Возвращаемое значение:
//   Число   – количество вхождений Слова в Текст
//
Функция ЧислоВхожденийСлова(Текст, Слово)
	Если Слово = "" Тогда
		Возврат 0;
	КонецЕсли;

	Результат = 0;
	Курсор = 1;
	ДлинаТекста = СтрДлина(Текст);
	ДлинаСлова = СтрДлина(Слово);

	Пока Курсор <> 0 Цикл
		Курсор = НайтиСледующееВхождениеСлова(Текст, Слово, Курсор);
		Если Курсор <> 0 Тогда
			Результат = Результат + 1;
			Курсор = Курсор + ДлинаСлова;
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;
КонецФункции

// процедура вычисляет цикломатическую сложность переданного текста и записывает результаты анализа в узел дерева
//
// Параметры
//  Текст  – Строка – текст анализируемого модуля
//
Процедура ВычислитьЦикломатическуюСложность(Знач Текст, УзелДереваРезультатов) Экспорт
	УбратьДвойныеКавычки(Текст);
	УбратьКомментарии(Текст);
	Если УбратьСтроковыеКонстанты(Текст) = 1 Тогда
		// ошибка при разборе
		УзелДереваРезультатов.ИмяМетода = "Нечетное количество кавычек в модуле. Анализ не произведен!";
		Возврат;
	КонецЕсли;
	УбратьДирективыКомпиляции(Текст, "#");
	УбратьДирективыКомпиляции(Текст, "&");

	// убираем объявление переменных
	НачалоПервогоМетода = СтрДлина(Текст);
	Курсор = НайтиСледующееВхождениеПодстроки(Текст, "Процедура");
	НачалоПервогоМетода = Мин(НачалоПервогоМетода, ?(Курсор = 0, НачалоПервогоМетода, Курсор));
	Курсор = НайтиСледующееВхождениеПодстроки(Текст, "Procedure");
	НачалоПервогоМетода = Мин(НачалоПервогоМетода, ?(Курсор = 0, НачалоПервогоМетода, Курсор));
	Курсор = НайтиСледующееВхождениеПодстроки(Текст, "Функция");
	НачалоПервогоМетода = Мин(НачалоПервогоМетода, ?(Курсор = 0, НачалоПервогоМетода, Курсор));
	Курсор = НайтиСледующееВхождениеПодстроки(Текст, "Function");
	НачалоПервогоМетода = Мин(НачалоПервогоМетода, ?(Курсор = 0, НачалоПервогоМетода, Курсор));
	Если НачалоПервогоМетода <> СтрДлина(Текст) Тогда
		Текст = Сред(Текст, НачалоПервогоМетода);
	КонецЕсли;

	МаксимальнаяСложностьУзлов = 0;
	Пока Текст <> "" Цикл
		//ОбработкаПрерыванияПользователя();
		ИмяМетода = "";
		Попытка
			ТекстМетода = ИзвлечьСледующийМетод(Текст, ИмяМетода);

			ЦикломатическаяСложность =
				1 + ЧислоВхожденийСлова(ТекстМетода, "Тогда")
				+ ЧислоВхожденийСлова(ТекстМетода, "Then")
				+ ЧислоВхожденийСлова(ТекстМетода, "Цикл")
				+ ЧислоВхожденийСлова(ТекстМетода, "Do")
				+ ЧислоВхожденийСлова(ТекстМетода, "Попытка")
				+ ЧислоВхожденийСлова(ТекстМетода, "Try")
				+ ЧислоВхожденийСлова(ТекстМетода, "Возврат")
				+ ЧислоВхожденийСлова(ТекстМетода, "Return")
				+ ЧислоВхожденийСлова(ТекстМетода, "ВызватьИсключение")
				+ ЧислоВхожденийСлова(ТекстМетода, "Raise")
				+ ЧислоВхожденийСлова(ТекстМетода, "Продолжить")
				+ ЧислоВхожденийСлова(ТекстМетода, "Continue")
				+ ЧислоВхожденийСлова(ТекстМетода, "Прервать")
				+ ЧислоВхожденийСлова(ТекстМетода, "Break")
				+ ?(Истина, ЧислоВхожденийСлова(ТекстМетода, "?"), 0);
			ТекущаяСтрока = УзелДереваРезультатов.Строки.Добавить();
			ТекущаяСтрока.Файл = УзелДереваРезультатов.Файл;
			ТекущаяСтрока.ИмяМетода = ИмяМетода;
			ТекущаяСтрока.ЦикломатическаяСложность = ЦикломатическаяСложность;
			МаксимальнаяСложностьУзлов = Макс(МаксимальнаяСложностьУзлов, ЦикломатическаяСложность);
		Исключение
			ТекущаяСтрока = УзелДереваРезультатов.Строки.Добавить();
			ТекущаяСтрока.Файл = УзелДереваРезультатов.Файл;
			ТекущаяСтрока.ИмяМетода = "Не удалось обработать модуль: " + ИмяМетода;
			ТекущаяСтрока.ЦикломатическаяСложность = 0;
		КонецПопытки;
	КонецЦикла;
	УзелДереваРезультатов.ЦикломатическаяСложность = МаксимальнаяСложностьУзлов;
КонецПроцедуры

// процедура расчитывает цикломатическую сложность реквизита ТекстМодуля
//
Процедура ВычислитьСложностьТекстаМодуля() Экспорт
	Лог.Информация("Анализ текста модуля...");
	ДеревоРезультатовАнализа.Строки.Очистить();

	ТекущийУзел = ДеревоРезультатовАнализа.Строки.Добавить();
	ТекущийУзел.Файл = "<Текст модуля>";
	ТекущийУзел.Путь = "";
	ВычислитьЦикломатическуюСложность(ТекстМодуля, ТекущийУзел);
	Лог.Информация("");
КонецПроцедуры

// процедура расчитывает цикломатическую сложность модулей файлов каталога
//
// Параметры
//  ПутьКаталога  – Строка – путь к анализируемому каталогу
//  МаскаФайлов   – Строка – маска для поиска файлов в каталоге
//
Процедура ВычислитьСложностьМодулейВКаталоге(ПутьКаталога, МаскаФайлов = "", ВключатьПодкаталоги = Ложь) Экспорт
	Если Не ЗначениеЗаполнено(ПутьКаталога) Тогда
		Возврат;
	КонецЕсли;

	Лог.Информация("Поиск файлов...");
	ТекущийФайл = Новый Файл(ПутьКаталога);

	Если ТекущийФайл.ЭтоКаталог() Тогда
		МассивФайлов = НайтиФайлы(ПутьКаталога, ?(ЗначениеЗаполнено(МаскаФайлов), МаскаФайлов, "*"), ВключатьПодкаталоги);
	Иначе
		МассивФайлов =  Новый Массив;
		МассивФайлов.Добавить(ТекущийФайл);
	КонецЕсли;

	Если МассивФайлов.Количество() = 0 Тогда
		Лог.Информация("Подходящий файлов не найдено!");
		Возврат;
	КонецЕсли;

	ДеревоРезультатовАнализа.Строки.Очистить();
	ТекстовыйФайл = Новый ТекстовыйДокумент;
	Для каждого ТекущийФайл Из МассивФайлов Цикл
		Лог.Информация("Анализ файла " + ТекущийФайл.ПолноеИмя + "...");

		Если ТекущийФайл.ЭтоФайл() Тогда
			ТекущийУзел = ДеревоРезультатовАнализа.Строки.Добавить();
			ТекущийУзел.Файл = ТекущийФайл.Имя;
			ТекущийУзел.Путь = ТекущийФайл.Путь;
			ТекстовыйФайл.Прочитать(ТекущийФайл.ПолноеИмя);
			ВычислитьЦикломатическуюСложность(ТекстовыйФайл.ПолучитьТекст(), ТекущийУзел);
		КонецЕсли;
	КонецЦикла;
	ТекстовыйФайл = Неопределено;

	Лог.Информация("");
	Лог.Информация("Анализ завершен!");
КонецПроцедуры

Парсер = Новый ПарсерАргументовКоманднойСтроки();
Парсер.ДобавитьПараметр("ПутьКИсходникам");
Парсер.ДобавитьПараметр("ПутьКЛогу");
Параметры = Парсер.Разобрать(АргументыКоманднойСтроки);

Лог = Логирование.ПолучитьЛог("oscript.app.cyclo");
Аппендер = Новый ВыводЛогаВФайл();
Аппендер.ОткрытьФайл(Параметры["ПутьКЛогу"]);
Лог.ДобавитьСпособВывода(Аппендер);

ВыводПоУмолчанию = Новый ВыводЛогаВКонсоль();
Лог.ДобавитьСпособВывода(ВыводПоУмолчанию);

Лог.Информация("Я расчётчик цикломатической сложности
|
|");

ДеревоРезультатовАнализа = Новый ДеревоЗначений;
ДеревоРезультатовАнализа.Колонки.Добавить("Путь");
ДеревоРезультатовАнализа.Колонки.Добавить("Файл");
ДеревоРезультатовАнализа.Колонки.Добавить("ИмяМетода");
ДеревоРезультатовАнализа.Колонки.Добавить("ЦикломатическаяСложность");

ВычислитьСложностьМодулейВКаталоге(Параметры["ПутьКИсходникам"],"*.bsl",Истина);

СуммаЦикломатикиПоОбъектам = 0;

Для каждого _строкаДерева из ДеревоРезультатовАнализа.Строки Цикл

	СуммаЦикломатикиПоОбъектам = СуммаЦикломатикиПоОбъектам + _строкаДерева.ЦикломатическаяСложность;

	Лог.Информация(" Файл " +  _строкаДерева.Путь + "\" + _строкаДерева.Файл + " cyclo - " + _строкаДерева.ЦикломатическаяСложность) ;

КонецЦикла;

Лог.Информация("Средняя цикломатическая сложность " + СуммаЦикломатикиПоОбъектам/ДеревоРезультатовАнализа.Строки.Количество());
