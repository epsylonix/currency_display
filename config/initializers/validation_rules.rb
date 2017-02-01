# regexp's for forms validation
# _VALID_DATE = '\s*\d\d[\.\/\-]\d\d[\.\/\-]\d{4}\s*\d{1,2}:\d{1,2}(:\d{1,2})?\s*'
# _VALID_CURRENCY = '\s*[\d]+[\s\d]*([\.\,][\d]+)?\s*'

# VALID_DATE_JS = "^#{_VALID_DATE}$"
# VALID_CURRENCY_JS = "^#{_VALID_CURRENCY}$"

# VALID_DATE_RB = "\A#{_VALID_DATE}\z"
# VALID_CURRENCY_RB = "\A#{_VALID_CURRENCY}\z"

FORM_VALIDATORS = {
    'date' =>      '\s*\d\d[\.\/\-]\d\d[\.\/\-]\d{4}\s*\d{1,2}:\d{1,2}(:\d{1,2})?\s*',
    'currency' =>  '\s*[\d]+[\s\d]*([\.\,][\d]+)?\s*'
}

FORM_VALIDATORS.keys.each do |key|
  FORM_VALIDATORS[key+'_js'] = "\^#{FORM_VALIDATORS[key]}\$"
  FORM_VALIDATORS[key+'_rb'] = "\\A#{FORM_VALIDATORS[key]}\\z"
end