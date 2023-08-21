// ignore_for_file: non_constant_identifier_names

class FireBaseConstants {
//users node constants
  static String userDbRoot = "Users";
  static String userName = "UserName";
  static String userImage = "UserImage";
  static String userEmail = "UserEmail";
  static String userNumber = "UserNumber";
  static String userDeviceToken = "DeviceTokken";
  static String userLastSeen = "LastSeen";
  static String userSkills = "Skills";
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// message node constants
  static String messageDbRoot = "Messages";
  static String messageType = "MessageType";
  static String messageSeen = "LastSeen";
  static String messageTimeStamp = "TimeStamp";
  static String messageText = "Message";
  static String messageFrom = "From";
  static String messageStatus = "Status";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Notification node constants
  static String notificationDbRoot = "Notifications";
  static String notificationFrom = "From";
  static String notificationType = "Type";
  static String notificationTitle = "Title";
  static String notificationBody = "Body";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Messages  types
  static String typeChat = "Chat";
  static String typeJob = "Job";
  static String typeApplyJob = "ApplyJob";
//broadcast
  static String typeNewJob = "NewJob";

  static String applyJobSingle = "apply_job_single_service_Provider";
  static String applyJobReward = "reward_customer";
  static String applyJobAccepted = "Accept/reject_service_provider";
  static String applyJobPayment = "payment_customer";
  static String applyJobStart = "job_start_service_provider";
  static String applyJobFinish = "job_finish_service_provider";
  static String applyJobApprove = "job_approve_customer";

  static String chatMessageCall = "FirebaseChatMessages";
  static String chatUserCall = "FireBaseChatUsers";
  static String unreadMessageCall = "FireBaseUnreadMessages";
//job messaages
  static String applyUserOtherMessage = "ApplyJobOtherUserMessage";
  static String applyUserCurrentMessage = "ApplyJobCurrentUserMessage";
  static String completedJobCurrntUserMessage =
      "CompletedJobCurrentUserMessage";
  static String completedJobOtherUserMessage = "CompletedJobOtherUserMessage";
  static String shortlistJobCurrentUserMessage =
      "hShortListJobCurrentUserMessage";
  static String shortlistJobOtherUserMessage = "ShortListJobOtherUserMessage";
  static String rewardJobCurrentUserMessage = "RewardJobCurrentUserMessage";
  static String rewardJobOtherUserMessage = "RewardJobOtherUserMessage";

  static String gigInviteCurrentUserMessage = "GigInviteCurrentUserMessage";
  static String gigInviteOtherUserMessage = "GigInviteOtherUserMessage";

  static String deliverJobOtherUserMessage = "DeliverJobOtherUserMessage";
  static String deliverJobCurrentUserMessage = "DeliverJobCurrentUserMessage";
  static String startedJobOtherUserMessage = "StartedJobOtherUserMessage";
  static String startedJobCurrentUserMessage = "StartedJobCurrentUserMessage";
//with Draw Requesr
  static String withDrawUserCurrentMessage = "WithDrawCurrentUserMessage";
  static String withDrawUserOtherMessage = "WithDrawOtherUserMessage";
//cancel Sp Message
  static String cancelSpCurrentMessage = "cancelSpCurrentUserMessage";
  static String cancelSpOtherMessage = "cancelSpOtherUserMessage";

  static String cancelled_JOB_CURRENT_USER_MESSAGE =
      "CancelledJobCurrentUserMessage";

  static String cancelled_JOB_OTHER_USER_MESSAGE =
      "CancelledJobOtherUserMessage";
  static String cancelled_CU_JOB_CURRENT_USER_MESSAGE =
      "CancelledCuJobCurrentUserMessage";

  static String cancelled_CU_JOB_OTHER_USER_MESSAGE =
      "CancelledCuJobOtherUserMessager";
  static String payment_CONFIRMED_CU_JOB_CURRENT_USER_MESSAGE =
      "PaymentConfirmedCuCurrentUserMessage";
  static String paymentConfirmedCuJobOtherUserMessage =
      "PaymentConfirmedCuOtherUserMessage";
  static String paymentConfirmedCuJobOtherUserMessage1 =
      "PaymentConfirmedCuOtherUserMessage1";

  static String DISPUTE_CU_JOB_CURRENT_USER_MESSAGE =
      "DISPUTECuJobCurrentUserMessage";
  static String DISPUTE_CU_JOB_OTHER_USER_MESSAGE =
      "DISPUTECuJobOtherUserMessager";

  static String CU_JOB_NOT_DELIVERED_CURRENT_USER_MESSAGE =
      "CuJobNotDeliveredCurrentUserMessage";
  static String CU_JOB_NOT_DELIVERED_OTHER_USER_MESSAGE =
      "CuJobNotDeliveredOtherUserMessage";
//invite sp on job
  static String CU_INVITE_ON_JOB_CURRENT_USER_MESSAGE =
      "CuInvitedOnJobCurrentUserMessage";
  static String CU_INVITE_ON_JOB_OTHER_USER_MESSAGE =
      "CuInvitedOnJobOtherUserMessage";
//edit proposal
  static String SP_EDIT_PROPOSAL_CURRENT_USER_MESSAGE =
      "SpEditProposalCurrentUserMessage";
  static String SP_EDIT_PROPOSAL_OTHER_USER_MESSAGE =
      "SpEditProposalOtherUserMessage";

  static String H_CHAT_ERROR_NO_USER = "No Users Found";
  static String H_CHAT_ERROR_UNABLE_TO_CONNECT = "Unable to connect, try again";

  static String H_CHAT_ERROR_RETRIEVING_USERS = "Error retrieving users";
  static String ACCEPTED_JOB_CURRENT_USER_MESSAGE =
      "AcceptedSpJobCurrentUserMessage";
  static String ACCEPTED_JOB_OTHER_USER_MESSAGE =
      "AcceptedSpJobOtherUserMessage";

  static String DISPUTED_JOB_CURRENT_USER_MESSAGE =
      "DisputedJobCurrentUserMessage";
  static String DISPUTED_JOB_OTHER_USER_MESSAGE = "DisputedJobOtherUserMessage";

//message type constant
  static String messageTypeText = "text";
  static String messageTypeImage = "Image";
//sender type
  static String senderText = "sender";
  static String receiverText = "receiver";
}
