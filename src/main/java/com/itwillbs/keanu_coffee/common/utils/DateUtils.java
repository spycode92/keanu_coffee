package com.itwillbs.keanu_coffee.common.utils;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.TemporalAdjusters;
import java.util.Date;

public class DateUtils {
//	returns timestamp values of previous month
//	needed to calculate which items should be put in priority locations in the warehouse
    public static Date[] getPreviousMonthRange() {
        LocalDateTime now = LocalDateTime.now();

        // First day of previous month at 00:00
        LocalDateTime startOfPrevMonth = now.minusMonths(1)
            .with(TemporalAdjusters.firstDayOfMonth())
            .withHour(0).withMinute(0).withSecond(0).withNano(0);

        // Last day of previous month at 23:59:59
        LocalDateTime endOfPrevMonth = now.minusMonths(1)
            .with(TemporalAdjusters.lastDayOfMonth())
            .withHour(23).withMinute(59).withSecond(59).withNano(999999999);

        Date startDate = Date.from(startOfPrevMonth.atZone(ZoneId.systemDefault()).toInstant());
        Date endDate = Date.from(endOfPrevMonth.atZone(ZoneId.systemDefault()).toInstant());

        return new Date[]{startDate, endDate};
    }
}

