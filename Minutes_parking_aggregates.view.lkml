view: minutes_parking_aggregates {
  derived_table: {
    sql:
      select siteid ,startday,
      date_format(date_parse(startday,'%Y-%m-%d'), '%W') as weekday,
      (9000000/(1000000*60)) as minute,
      occpercent , turnovers
      from dwh_aggregation_parking_spot
      WHERE  startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
      ;;

  }

  suggestions: yes

  dimension: siteid {
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: startday {
    type: string
    sql: ${TABLE}.startday ;;
  }

  dimension: weekday {
    type: string
    sql: ${TABLE}.weekday ;;
  }

  dimension: minute {
    type: number
    sql: ${TABLE}.minute ;;
  }
  dimension: occpercent {
    type: string
    sql: ${TABLE}.occpercent ;;
  }

  dimension: turnovers {
    type: string
    sql: ${TABLE}.turnovers ;;
  }



  }
