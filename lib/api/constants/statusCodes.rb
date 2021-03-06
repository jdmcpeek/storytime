
module STATUS_CODES
  SUCCESS               = 200
  CREATE_USER_SUCCESS   = 201
  REFRESH_TKN_CREATED		= 20101
  MISSING_CREDENTIALS   = 400
  NO_MATCHING_SCHOOL    = 401
  NO_EXISTING_USER      = 402
  NO_VALID_ACCESS_TKN   = 403
  WRONG_PASSWORD        = 404
  WRONG_ACCESS_TKN_TYPE = 405
  CREDENTIALS_MISSING   = 40000
  PASSWORD_UPDATE_FAIL  = 40001
  CREDENTIALS_INVALID   = 40002
  PHONE_NOT_FOUND       = 41000
  SMS_CODE_WRONG        = 42000
  TOKEN_EXPIRED         = 43000
  TOKEN_INVALID         = 43001
  TOKEN_CORRUPT         = 43002
  TOKEN_WRONG           = 43003
  TOKEN_CREATION_FAILED = 43004
  USER_NOT_EXIST        = 45000
  INTERNAL_ERROR 				= 500
  NOTIFY_ADMINS_FAIL	  = 50001
end

