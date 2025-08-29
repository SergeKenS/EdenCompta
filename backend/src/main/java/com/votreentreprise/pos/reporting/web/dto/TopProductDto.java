package com.votreentreprise.pos.reporting.web.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record TopProductDto(
        UUID productId,
        String name,
        BigDecimal qtySold
) {}


