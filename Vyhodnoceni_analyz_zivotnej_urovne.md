# PROJEKT: Analýza životnej úrovne občanov ČR

## Úvod do projektu

Oddelenie dátovej analytiky nezávislej spoločnosti zaoberajúcej sa výskumom životnej úrovne obyvateľstva sa rozhodlo zodpovedať niekoľko výskumných otázok, ktoré sa týkajú dostupnosti základných potravín pre širokú verejnosť. Cieľom je pripraviť analytický výstup, ktorý bude slúžiť ako podklad pre tlačové oddelenie, a následne bude prezentovaný na tematickej konferencii zameranej na túto oblasť.

Úlohou je pripraviť komplexný dátový podklad, na základe ktorého bude možné porovnať dostupnosť vybraných potravín vo vzťahu k priemerným mzdám v priebehu niekoľkých rokov. Okrem údajov za Českú republiku je potrebné doplniť aj prehľad HDP, GINI koeficientu a populácie ďalších európskych krajín, ktoré budú slúžiť ako referenčný rámec v rovnakom časovom období.

---

## Ciele projektu

- Zodpovedať konkrétne výskumné otázky o vývoji cien a miezd.
- Porovnať vývoj cien potravín vo vzťahu k mzdám v priebehu rokov.
- Doplniť údaje o ďalších európskych krajinách ako referenčný rámec.

---

## Použité dátové sady

### Primárne tabuľky

| Tabuľka | Popis |
|--------|--------|
| `czechia_payroll` | Údaje o mzdách podľa odvetví |
| `czechia_payroll_calculation` | Spôsob výpočtu miezd |
| `czechia_payroll_industry_branch` | Kategórie odvetví |
| `czechia_payroll_unit` | Jednotky výpočtu miezd |
| `czechia_payroll_value_type` | Typy údajov v mzdách |
| `czechia_price` | Vývoj cien potravín |
| `czechia_price_category` | Kategórie potravín |
| `czechia_region` | Kraje podľa CZ-NUTS 2 |
| `czechia_district` | Okresy podľa LAU |

### 🔹 Sekundárne tabuľky

- `countries` – údaje o krajinách (hlavné mesto, mena, výška, jedlo…)
- `economies` – ekonomické ukazovatele (HDP, GINI, dane…)

---

## Výskumné otázky

1. Dochádza k rastu miezd vo všetkých odvetviach?
2. Koľko mlieka/chleba možno kúpiť za priemernú mzdu v prvom a poslednom sledovanom období?
3. Ktorá potravina má najnižší medziročný rast ceny?
4. Bol rok, kedy ceny potravín rástli o viac než 10 % viac ako mzdy?
5. Má HDP vplyv na vývoj miezd a cien potravín?

---

## Príprava dát

### Primárna dátová sada:

Spájanie dát z tabuliek:
- `czechia_price` (alias `cpr`) – ceny potravín
- `czechia_payroll` (alias `cpay`) – mzdy
- `czechia_payroll_industry_branch` (alias `cpib`) – odvetvia
- `czechia_price_category` (alias `cpc`) – kategórie potravín

Výstup obsahuje:
- kategória jedla
- priemerná cena a množstvo
- jednotky
- rok a región
- odvetvie a priemerná mzda
- spôsob výpočtu mzdy

> ⚠️ Zistená chyba:  
> Počas vytvárania podkladov bola vypozorovaná chyba v tabuľke czechia_payroll_unit kde hodnoty logicky nesedia s hodnotami uvedenými v tabuľke czechia_payroll. Czechia_payroll_unit uvádza, že v stĺpci payroll_unit hodnota **200** má zodpovedať hodnote **tis. osôb** a hodnota **80403** by mala zodpovedať hodnote mzdy v **českých korunách**, ale logicky to nesedí. Na základe hodnôt uvedených v indicator_type (value_type_code) možeme predpokladať, že hodnoty v Czechia_payroll_unit boli zamenené - to znamená 200 je hodnota označujúca **české koruny** a hodnota 80403 je hodnota označujúca **tis. osob**. S touto informáciou sa pracuje v analýzach.

### 🔧 Sekundárna dátová sada:

- Spojené tabuľky `countries` a `economies`
- Filtrované iba na európske štáty (2006–2018)
- Pripojené české údaje z primárnej tabuľky pre porovnanie vývoja HDP a cien/miezd

---

## Vypracovanie výskumných otázok

### 1. Rastú mzdy vo všetkých odvetviach?
-  Mzdy v dlhodobom horizonte rastú takmer vo všetkých odvetviach, ale v niektorých rokoch a v niektorých odvetviach dochádza ku krátkodobým poklesom. Jedine v odvetviach Ostatní činnosti a Zdravotní a sociální péče nebol zaznamenaný žiaden pokles. V ostatných odvetviach dochádza ku krátkodobému poklesu najmä v období medzi rokmi 2009 až 2013 čo môže byť dôsledkom finančnej krízy.

### 2. Koľko mlieka/chleba možno kúpiť za mzdu?

| Rok | Mlieko (l) | Chlieb (kg) |
|-----|------------|-------------|
| 2006 | 1460 l | 1308 kg |
| 2018 | 1667 l | 1363 kg |

- Priemerná mzda medzi rokmi narástla viac ako ceny potravín, takže si človek mohol dovoliť nakúpiť viac, čiže kúpna sila sa v prípade týchto dvoch základných potravín navýšila, výraznejšie pri mlieku.

### 3. Najpomalší rast ceny?

- **Cukr krystálový**  
-  Cukr krystálový je potravina, ktorá zdražuje najpomalšie.
  → medziročný pokles **−1.92 %**

### 4. Ceny potravín vs. mzdy (10 % rozdiel)?

- V analyzovanom období nebol ani jeden rok, v ktorom by ceny potravín rástli výrazne viac ako mzdy (t.j. o viac ako 10 %). Aj v rokoch, kde rástli potraviny rýchlejšie ako mzdy (napr. 2013), rozdiel nikdy neprekročil túto hranicu.

### 5. Vplyv HDP?

- Vo väčšine prípadov vyšší rast HDP v predchádzajúcom roku koreluje s rastom miezd v aktuálnom roku. Súčasne, ak HDP poklesol, mzdy sa spravidla spomalili alebo dokonca klesli (napr. 2010 a 2013). U potravín je tento vzťah menej jednoznačný. Napriek vysokému rastu HDP v niektorých rokoch (napr. 2016), ceny potravín aj tak klesali. Naopak, ceny potravín niekedy rástli aj pri stagnácii HDP (napr. 2013). To naznačuje, že na ceny potravín pôsobia aj iné faktory ako len HDP.

---

## Autorka

Sabína Novotná
https://github.com/ssabbinn
Vypracované ako študijný projekt.

## Licencia

Projekt je určený pre výučbu a nekomerčné použitie.
