codeManager <- R6::R6Class(
  classname = "codeManager",
  public = list(
    initialize = function() {
      private$reactive_code <- reactiveVal("")
    },
    set_value = function(value) {
      private$reactive_code(value)
    },
    get_value_as_reactive = function() {
      private$reactive_code
    }
  ),
  private = list(
    reactive_code = NULL
  )
)
