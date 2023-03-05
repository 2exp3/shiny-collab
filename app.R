library(shiny)
library(R6)

source("codeManager.R")

code_manager <- codeManager$new()

ui <- fluidPage(
  tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
  titlePanel("Shiny Collab"),
  fluidRow(
    column(7, tags$h4("Live share your code below")),
    column(5, actionButton("run_code", h4(icon("play"), "Run")))
  ),
  fluidRow(
    column(7, tags$textarea(id = "code_area")),
    column(5, verbatimTextOutput("code_output"))
  )
)

server <- function(input, output, session) {
  observeEvent(input$code_area, {
    code_manager$set_value(input$code_area)
  }, ignoreInit = TRUE)

  current_code <- code_manager$get_value_as_reactive()

  observeEvent(current_code(), {
    # Do not update code area that's being currently used.
    if (!identical(input$code_area, current_code())) {
      updateTextAreaInput(
        session = session,
        inputId = "code_area",
        value = current_code()
      )
    }
  }, ignoreInit = TRUE)

  observeEvent(input$run_code, {
    code <- current_code()
    output$code_output <- renderText({
      paste(
        utils::capture.output(
          eval(
            parse(text = code)
          )
        ),
        collapse = "\n"
      )
    })
  }, ignoreInit = TRUE)
}

shinyApp(ui, server)
