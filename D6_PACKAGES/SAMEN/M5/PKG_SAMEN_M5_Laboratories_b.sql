create PACKAGE BODY PKG_SAMEN_M5_LABORATORIES
AS
    --random functions---
    FUNCTION random_numeric(p_min NUMERIC, p_max NUMERIC)
        RETURN NUMERIC
    AS
    BEGIN
        RETURN TRUNC(DBMS_RANDOM.VALUE(p_min, p_max));
    END random_numeric;


    --random procedure---
    PROCEDURE random_number(p_min NUMERIC, p_max NUMERIC)
    AS
        v_number NUMERIC := TRUNC(DBMS_RANDOM.VALUE(p_min, p_max));
    BEGIN
        DBMS_OUTPUT.PUT_LINE('1 - Random nummer binnen een bereik: ' || u'\000D\000A' || 'random_number(' || p_min ||
                             ',' || p_max ||
                             ') --> ' || v_number);
    END random_number;

    PROCEDURE random_startdatum(p_startdate DATE, p_enddate DATE)
    AS
        v_difference INTEGER := (p_enddate - p_startdate);
        v_addition   NUMBER  := random_numeric(1, v_difference);
    BEGIN
        DBMS_OUTPUT.PUT_LINE('2 - random datum binnen een bereik: ' || u'\000D\000A' ||
                             'random_startdatum(sysdate - 100, sysdate)  --> ' || (p_startdate + v_addition));
    END random_startdatum;

    PROCEDURE random_firstname
    AS
        TYPE type_tab_type IS TABLE of CONTACTS.FIRST_NAME%TYPE;
        t_firstname type_tab_type            := type_tab_type('Stef', 'Andreas', 'Bart', 'Jos', 'Ann', 'Abby',
                                                              'Bianca', 'Lorenz', 'Paul', 'Laura', 'Anouk', 'Zoë',
                                                              'Davy', 'Maarten', 'Jiri', 'Mike', 'Nils', 'Geert',
                                                              'Leen', 'Regina', 'Jan-Willem');
        v_number    CONTACTS.FIRST_NAME%TYPE := random_numeric(1, t_firstname.COUNT);
    BEGIN
        DBMS_OUTPUT.PUT_LINE(' 3 - random name uit een lijst: ' || u'\000D\000A' || 'random_firstname --> ' ||
                             t_firstname(v_number));
    END random_firstname;

    PROCEDURE random_street_and_number(p_max_street_number LABORATORIES.LABORATORY_STREET_NUMBER%TYPE)
    AS
        TYPE type_tab_streetNames IS TABLE OF LABORATORIES.LABORATORY_STREET%TYPE;
        t_street        type_tab_streetNames                       := type_tab_streetNames('Abtenstraat',
                                                                                           'Averbodestraat',
                                                                                           'Berendrechtsluis',
                                                                                           'Berendrechtweg',
                                                                                           'Biestraatje', 'Binnenpad',
                                                                                           'Bokspane',
                                                                                           'Bonkelaarstraat',
                                                                                           'Bosdreef', 'Boterbekeweg',
                                                                                           'Breedsteert',
                                                                                           'Buitenmolenweg',
                                                                                           'Burgemeester Verhulstplein',
                                                                                           'Cecilianenstraat',
                                                                                           'Derdeweg',
                                                                                           'Dominicanenstraat',
                                                                                           'Dopheidestraat',
                                                                                           'Dorpsbeekstraat',
                                                                                           'Emelinusstraat',
                                                                                           'Franciscanenstraat',
                                                                                           'Frederik-Hendrikstraat',
                                                                                           'Gansrijdersstraat',
                                                                                           'Gillis Damaesstraat',
                                                                                           'Goudhoekstraat',
                                                                                           'Hagelberg',
                                                                                           'Heesterbos', 'Heiblokken',
                                                                                           'Hoefbladstraat',
                                                                                           'Keyserstraatje',
                                                                                           'Kleine Bredestraat',
                                                                                           'Kluisdijk',
                                                                                           'Kommershoek',
                                                                                           'Konijnendreef', 'Krommeweg',
                                                                                           'Kruisbos',
                                                                                           'Magershoek',
                                                                                           'Middelburgstraat',
                                                                                           'Monnikenhofstraat',
                                                                                           'Neerhoefstraat',
                                                                                           'Norbertijnenstraat',
                                                                                           'Oostmolengeest',
                                                                                           'Oude Papenstraat',
                                                                                           'Oudedijkweg',
                                                                                           'Pastoor Verlindenstraat',
                                                                                           'Piep-in-‘t-Riet',
                                                                                           'Pootersstraat',
                                                                                           'Potpolderweg',
                                                                                           'Predikherenbos',
                                                                                           'Prelatenstraat',
                                                                                           'Raapakker',
                                                                                           'Reigersbosdreef',
                                                                                           'Rietbank');
        v_street_picker NUMERIC                                    := random_numeric(1, t_street.COUNT);
        v_street_number LABORATORIES.LABORATORY_STREET_NUMBER%TYPE := random_numeric(1, p_max_street_number);
    BEGIN
        DBMS_OUTPUT.PUT_LINE('4- random straatnaam met huisnummer (maximale huisnummer als parameter): ' ||u'\000D\000A'|| 'random_street_and_number(' || p_max_street_number || ') --> ' || t_street(v_street_picker) ||
                             ' ' || v_street_number);
    END random_street_and_number;

    PROCEDURE bewijs_M5
    AS
    BEGIN
        random_number(1, 20);
        random_startdatum(sysdate - 100, sysdate);
        random_firstname();
        random_street_and_number(300);
    END bewijs_M5;

END PKG_SAMEN_M5_LABORATORIES;
/
