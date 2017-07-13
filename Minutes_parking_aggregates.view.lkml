view: minutes_parking_aggregates {
  derived_table: {
    sql:
      select hist.siteid as siteid,
             hist.startday as startday,
             hist.weekday as weekday,
             hist.occduration as minute,
             hist.occpercent as minutes_occupancy_percentage,
             hist.turnovers as minutes_parked_vehicles


      from
      (
      SELECT siteid, startday,(occduration/(100000*60)) as minute,occpercent,turnovers
             date_format(date_parse(startday,'%Y-%m-%d'), '%W') as weekday
      FROM   dwh_aggregation_parking_spot
      WHERE  startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
      GROUP BY siteid, startday,minute
      ) hist
      LEFT OUTER JOIN
      (
      SELECT siteid, startday,(occduration/(100000*60)) as minute,occpercent,
             date_format(date_parse(startday,'%Y-%m-%d'), '%W') as weekday
      FROM   dwh_aggregation_parking_spot
      WHERE  startday > date_format(date_add('day',-8,current_date), '%Y-%m-%d')
      and    case date_format(date_parse(startday,'%Y-%m-%d'),'%W')
             when 'Monday' then 1
             when 'Tuesday' then 2
             when 'Wednesday' then 3
             when 'Thursday' then 4
             when 'Friday' then 5
             when 'Saturday' then 6
             when 'Sunday' then 7
             end
             <=
             case date_format(current_date,'%W')
             when 'Monday' then 1
             when 'Tuesday' then 2
             when 'Wednesday' then 3
             when 'Thursday' then 4
             when 'Friday' then 5
             when 'Saturday' then 6
             when 'Sunday' then 7
             end
      GROUP BY siteid, startday, starthr
      ) week
      ON     hist.siteid = week.siteid
      AND    hist.weekday = week.weekday
      AND    hist.minute = week.minute

      ORDER  By hist.siteid, hist.startday,hist.minute
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

  dimension: occduration {
    type: number
    sql: ${TABLE}.occduration ;;
  }

  dimension_group: day_details {
    type: time
    timeframes: []
    sql: date_parse(${TABLE}.startday,'%Y-%m-%d') ;;
  }

  }
