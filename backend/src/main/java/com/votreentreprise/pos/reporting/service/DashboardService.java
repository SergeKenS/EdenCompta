package com.votreentreprise.pos.reporting.service;

import com.votreentreprise.pos.reporting.web.dto.DashboardSummaryDto;

import java.time.LocalDateTime;
import java.util.UUID;

public interface DashboardService {
    DashboardSummaryDto buildSummary(UUID storeId, LocalDateTime from, LocalDateTime to);
}


