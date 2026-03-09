# -------------------------------------------------------------------------
# SAVING FUNCTIONS
# -------------------------------------------------------------------------
library(tidyverse) # Required for ggsave

# -------------------------------------------------------------------------
# CONFIGURATION
# -------------------------------------------------------------------------
# Define the sizes and scaling for each context here.
# NOTE: width and height are in INCHES.
# This makes it easy to change "standard sizes" in one place!

plot_settings <- list(
    "report" = list(
        width = 8,
        height = 8,
        scale = 1.5 # Balanced text size for documents
    ),
    "poster" = list(
        width = 20,
        height = 15,
        scale = 0.5 # Scale < 1 zooms IN (makes text/elements larger relative to canvas)
    ),
    "presentation" = list(
        width = 10,
        height = 7.5,
        # User requested the 'balanced' report look for presentation too
        scale = 1
    ),
    "single_report" = list(
        width = 4,
        height = 4,
        scale = 2
    ),
    "single_poster" = list(
        width = 12,
        height = 10,
        scale = 0.5
    ),
    "single_presentation" = list(
        width = 12,
        height = 10,
        scale = 0.5
    )
)


# -------------------------------------------------------------------------
# FUNCTIONS
# -------------------------------------------------------------------------

# Save a plot as a PNG (Raster image)
#
# Arguments:
#   plot: The plot object you want to save
#   filename: What to call the file (e.g., "my_plot.png")
#   size_option: Either "report", "poster", or "presentation"
#
save_penguin_plot_png <- function(plot,
                                  filename,
                                  size_option = "report") {
    # 1. Get the settings for the chosen option
    settings <- plot_settings[[size_option]]

    # Check if we found valid settings
    if (is.null(settings)) {
        stop("size_option must be 'report', 'poster', or 'presentation'")
    }

    # 2. Make sure the 'figures' folder exists
    if (!dir.exists("figures")) {
        dir.create("figures")
        message("Created 'figures' folder.")
    }

    # 3. Create the full path (e.g., "figures/my_plot.png")
    full_path <- file.path("figures", filename)

    # 4. Save the plot
    ggsave(
        filename = full_path,
        plot = plot,
        width = settings$width,
        height = settings$height,
        units = "in",
        scale = settings$scale,
        dpi = 300, # High quality for print
        bg = "white", # Prevent transparent backgrounds
        limitsize = FALSE
    )

    message(paste("Saved", size_option, "plot to", full_path))
}


# Save a plot as an SVG (Vector image)
#
# Arguments:
#   plot: The plot object you want to save
#   filename: What to call the file (e.g., "my_plot.svg")
#   size_option: Either "report", "poster", or "presentation"
#
save_penguin_plot_svg <- function(plot,
                                  filename,
                                  size_option = "report") {
    # 1. Get the settings
    settings <- plot_settings[[size_option]]

    if (is.null(settings)) {
        stop("size_option must be 'report', 'poster', or 'presentation'")
    }

    # 2. Make sure 'figures' folder exists
    if (!dir.exists("figures")) {
        dir.create("figures")
    }

    # 3. Create full path
    full_path <- file.path("figures", filename)

    # 4. Save (No dpi needed for vector)
    ggsave(
        filename = full_path,
        plot = plot,
        width = settings$width,
        height = settings$height,
        units = "in",
        scale = settings$scale,
        bg = "white",
        limitsize = FALSE
    )

    message(paste("Saved", size_option, "plot to", full_path))
}
