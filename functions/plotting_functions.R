# -------------------------------------------------------------------------
# Modular Plotting Functions
# -------------------------------------------------------------------------
# Purpose: Define reusable ggplot2 functions for consistent visualisation.

# 1. Setup
# -------------------------------------------------------------------------

# Load required packages

library(tidyverse)

# 2. Shared Themes and Palettes
# -------------------------------------------------------------------------

# Define standard species colour palette
species_colours <- c(
                    "Adelie" = "darkorange",
                    "Chinstrap" = "purple",
                    "Gentoo" = "cyan4"
                )

# Define custom publication-ready theme (based on theme_minimal)
theme_penguin <- function(base_size = 13, ...) {
    theme_minimal(base_size = base_size, ...) +
        theme(
            plot.title = element_text(face = "bold", size = 13),
            plot.subtitle = element_text(size = 10, margin = margin(b = 10)),
            axis.title = element_text(size = 12),
            panel.grid.minor = element_blank(),
            legend.position = "none" # Default to no legend (can be overridden)
        )
}


# 3. Primary Plotting Functions
# -------------------------------------------------------------------------


# Plot a customised boxplot for penguin measurements
#
# Arguments:
#   data: Data frame containing penguin data
#   x_var: Variable for the x-axis (categorical)
#   y_var: Variable for the y-axis (numerical)
#   title_text: Plot title
#   subtitle_text: Plot subtitle
#   x_label: Label for the x-axis
#   y_label: Label for the y-axis
#
# Returns:
#   A ggplot object


plot_penguin_boxplot <- function(data,
                                 x_var,
                                 y_var,
                                 title_text = "Morphological Variability by Species",
                                 subtitle_text = " ",
                                 x_label = "Species",
                                 y_label = "Measurement") {
  ggplot(
    data,
    aes(
      x = {{ x_var }},
      y = {{ y_var }},
      colour = {{ x_var }}
    )
  ) +
    geom_boxplot(
      width = 0.2,
      outlier.shape = NA,
      alpha = 0.1,
      colour = "grey30"
    ) +
    geom_point(
      size = 1,
      alpha = 0.4, 
      position = position_jitter(width = 0.18, seed = 123)
    ) +
    scale_colour_manual(values = species_colours) +
    labs(
      title = title_text,
      subtitle = subtitle_text,
      x = x_label,
      y = y_label
    ) +
    theme_penguin() +
    theme(panel.grid.major.x = element_blank())
}



# 4. Advanced Visualisation Functions
# -------------------------------------------------------------------------

# Plot clusters with confidence ellipses
#
# Arguments:
#   data: Data frame containing penguin data
#   x_var: Variable for the x-axis (numerical)
#   y_var: Variable for the y-axis (numerical)
#   colour_var: Variable to group by colour (categorical)
#   title: Plot title
#   subtitle: Plot subtitle
#   x_label: Label for the x-axis (optional, defaults to variable name)
#   y_label: Label for the y-axis (optional, defaults to variable name)
#
# Returns:
#   A ggplot object

plot_clusters <- function(data,
                          x_var,
                          y_var,
                          colour_var,
                          title,
                          subtitle,
                          x_label = NULL,
                          y_label = NULL) {
    # Simplification: If labels aren't provided, use the variable names
    if (is.null(x_label)) x_label <- rlang::as_name(rlang::enquo(x_var))
    if (is.null(y_label)) y_label <- rlang::as_name(rlang::enquo(y_var))

    ggplot(
        data,
        aes(
            x = {{ x_var }},
            y = {{ y_var }},
            colour = {{ colour_var }}
        )
    ) +
        geom_point(size = 2, alpha = 0.7) +
        # Use stat_ellipse for robust confidence regions
        stat_ellipse(
            aes(fill = {{ colour_var }}),
            geom = "polygon",
            alpha = 0.2,
            colour = NA,
            level = 0.95,
            show.legend = FALSE
        ) +
        scale_colour_manual(values = species_colours) +
        scale_fill_manual(values = species_colours) +
        labs(
            title = title,
            subtitle = subtitle,
            x = x_label,
            y = y_label
        ) +
        theme_penguin()
}

# Helper function to calculate linear regression statistics
#
# Arguments:
#   data: Data frame containing penguin data
#   x_var: Independent variable (numerical)
#   y_var: Dependent variable (numerical)
#   colour_var: Grouping variable (categorical)
#
# Returns:
#   A data frame with regression statistics and labels

calculate_regression_stats <- function(data, x_var, y_var, colour_var) {
    data |>
        # 1. Standardise column names using tidy evaluation ({{ }})
        # This allows the function to work with any column names provided
        rename(
            x = {{ x_var }},
            y = {{ y_var }},
            group = {{ colour_var }}
        ) |>
        # 2. Group the data by our species/categorical variable
        group_by(group) |>
        # 3. Perform the regression analysis for each group separately
        #   The do() function allows us to perform operations on each group
        do({
            # Fit a linear model: y as a function of x
            #   The . means the output from the previous step.
            model <- lm(y ~ x, data = .)

            # Extract statistics and format them into a neat string for the legend
            #   The $ means we're accessing a column from the data frame
            #   The unique() function ensures we only get one of each species
            #   The sprintf() function formats the string to make it look nice
            #   -10s means left-align the string to a width of 10 characters
            #   %.2f means format the number to 2 decimal places
            tibble(
                group = unique(.$group),
                label = sprintf(
                    "%-10s  y = %.2fx + %.2f   R² = %.2f",
                    unique(.$group), # Species name
                    coef(model)[2], # Slope (gradient)
                    coef(model)[1], # Intercept
                    summary(model)$r.squared # Coefficient of determination
                )
            )
        })
}

# Plot regression lines with statistics
#
# Arguments:
#   data: Data frame containing penguin data
#   x_var: Independent variable (numerical)
#   y_var: Dependent variable (numerical)
#   colour_var: Grouping variable (categorical)
#   title: Plot title
#   subtitle: Plot subtitle
#   x_label: Label for the x-axis
#   y_label: Label for the y-axis
#
# Returns:
#   A ggplot object

plot_regression <- function(data,
                            x_var,
                            y_var,
                            colour_var,
                            title,
                            subtitle = NULL,
                            x_label = NULL,
                            y_label = NULL) {
    # Default axis labels if not provided
    if (is.null(x_label)) x_label <- rlang::as_name(rlang::enquo(x_var))
    if (is.null(y_label)) y_label <- rlang::as_name(rlang::enquo(y_var))

    # Use our helper function to get the stats
    regression_labels <- calculate_regression_stats(
        data,
        {{ x_var }},
        {{ y_var }},
        {{ colour_var }}
    )

    # Create a named vector for the legend labels
    legend_labels <- setNames(regression_labels$label, regression_labels$group)

    ggplot(
        data,
        aes(
            x = {{ x_var }},
            y = {{ y_var }},
            colour = {{ colour_var }}
        )
    ) +
        geom_point(size = 2, alpha = 0.6) +
        geom_smooth(method = "lm", se = FALSE, linewidth = 1) +
        scale_colour_manual(
            values = species_colours,
            labels = legend_labels,
            name = NULL
        ) +
        labs(
            title = title,
            subtitle = subtitle,
            x = x_label,
            y = y_label
        ) +
        theme_penguin() +
        theme(
            legend.position = "bottom",
            legend.justification = "right",
            legend.direction = "vertical",
            legend.text = element_text(size = 13, family = "Courier New"),
            legend.key.width = unit(0.8, "lines")
        )
}
