import 'package:odlay_services/AppFiles/Utility/FirebaseConstants.dart';

class GetChatMessageJob {
  static final String hApplyJobOtherUserMessageContent =
      "Service provider: %s" +
          " applied on your job titled: %s" +
          " with a bid amount %s to be completed in %s days. \n" +
          "Please go to your job manager to view the detail";

  static final String hApplyJobCurrentUserMessageContent =
      "You applied on job titled: %s" +
          " with a bid amount of %s to be completed in %s days.";

  static final String hCompletedJobCurrentUserMessageContent =
      "You marked your job titled: %s" +
          " as completed by the service provider: %s ";

  static final String hCompletedJobOtherUserMessageContent =
      "Customer: %s" + " approved your job titled: %s as completed.";

  static final String hShortListCurrentUserMessageContent =
      "You shortlisted the Service Provider: %s" + "for your job titled: %s ";

  static final String hShortListOtherUserMessageContent =
      "Customer: %s" + " shortlisted you for the job titled: %s";

  static final String hRewardCurrentUserMessageContent =
      "You hired the Service Provider: %s" + " for your job titled: %s ";

  static final String hRewardOtherUserMessageContent =
      "The customer %s " + " has awarded you the job titled: %s";

// //Gig invite other msg
  static final String hGigInviteOtherUserMessageContent =
      "Your fixed price service titled %s has been purchased by the customer %s " +
          " for a total quantity of %s " +
          " at a total price %s. " +
          "Please accept the job and wait for the customer's payment before starting the job.";

  static final String hGigInviteCurrentUserMessageContent =
      "You have successfully hired the service provider %s " +
          "for the fixed price service titled %s " +
          "for a total quantity of %s " +
          "at a total price of %s. " +
          "Please wait for the service provider response.";

  static final String hDeliveredCurrentUserMessageContent =
      "You completed the work on job titled: %s \n " + "created by: %s ";

  static final String hDeliveredOtherUserMessageContent =
      "Service Provider: %s" + "f inished the work on your job titled: %s";

  static final String hStartedCurrentUserMessageContent =
      "You have started working on job titled: %s" + " created by: %s ";

  static final String hStartedOtherUserMessageContent =
      "Service Provider: %s" + " started working on your job titled: %s";
  static final String hCancelSpJobCurrentUserMessageContent =
      "You Canceled the job titled: %s by customer: %s ";
  static final String hCancelSpJobOtherUserMessageContent =
      "Service Provider %s cancelled the job titled %s ";

  static final String hCancelCuJobCurrentUserMessageContent =
      "You canceled the job titled: %s for service provider %s ";
  static final String hCancelCuJobOtherUserMessageContent =
      "Customer %s cancelled the job titled: %s for you";

  static final String hDISPUTECuJobCurrentUserMessageContent =
      "The service provider %s is not happy with the jobs titled %s and has made a complaint to the customer support. Please wait for Odlay services team response to help you and the other party resolve this issue";
  static final String hDISPUTECuJobOtherUserMessageContent =
      "The customer %s is not happy with the job titled %s and has made a complaint to the customer support. Please wait for Odlay services team response to help you and the other party resolve this issue";

  String hAcceptedJobCurrentUserMessageContent =
      "you accepted the job titled: %s by customer: %s ," +
          " please wait for customer: %s payment confirmation.";
  String hAcceptedJobOtherUserMessageContent =
      "Your job titled: %s has been accepted by service provider: %s , " +
          "Please confirm payment method.";
  String hPaymentConfirmedJobCurrentUserMessageContent =
      "You selected %s as a payment option for the job titled: %s for " +
          "the service provider %s";
  String hPaymentConfirmedJobOtherUserMessageContent =
      "The customer %s has successfully made payment for the job titled %s. You can start working on this job.";
      String hPaymentConfirmedJobOtherUserMessageContent1 =
      "The customer %s has decided to use cash payment for the job titled %s. Please collect the payment from the customer at the end of the job.Please always advise your customers to use online payment for the job so that a payment for your job is guaranteed.";
  String hJobNotDeliveredCurrentUserMessage =
      "you did not approve the job titled: %s as " +
          "completed for service provider %s. The job status is again in progress. Please speak to the service provider and explain why you feel the job is still incomplete ";
  String hJobNotDeliveredOtherUserMessage =
      "The customer %s  believes that %s job is not finished and has changed the status back to in progress.Please contact the customer and finish the job according to the agreed terms. In case of questions, please contact customer support.";

  static final String hDISPUTEDSpJobOtherUserMessageContent =
      "The customer %s is not happy with the progress of the job titled %s and has made a complaint to the customer support. Please wait for Odlay services team response to help you and the other party resolve this issue";

  static final String hDISPUTEDCuJobCurrentUserMessageContent =
      "The customer %s is not happy with the progress of the job titled %s and has made a complaint to the customer support. Please wait for Odlay services team response to help you and the other party resolve this issue";

//invite on job
  static final String hInviteSpOnJobOtherUserMessageContent =
      "The customer %s has invited you to submit your offer to his job titled %s";

  static final String hInviteSpOnJobCurrentUserMessageContent =
      "You have invited the service provider %s to submit his offer to your job titled %s";
//edit proposal
  static final String hEditProposalOtherUserMessageContent =
      "The Service Provider %s has updated his bid amount in his offer to your job titled %s";

  static final String hEditProposalCurrentUserMessageContent =
      "You have updated the bid amount to you offer for the job titled %s";
//with draw request messages
  static final String hWithDrawSpJobCurrentUserMessageContent =
      "You WithDraw your request from  the job titled: %s by customer: %s ";
  static final String hWithDrawOtherUserMessageContent =
      "Service Provider %s With Draw his Applicantion the job titled %s ";
//gettting Mesasge on the basis of job event

  String getChatMessage(String keyEvent) {
    String chatMessage = "";
    switch (keyEvent) {
      case "ApplyJobOtherUserMessage":
        {
          chatMessage = hApplyJobOtherUserMessageContent;
        }
        break;

      case "ApplyJobCurrentUserMessage":
        {
          chatMessage = hApplyJobCurrentUserMessageContent;
        }
        break;

      case "AcceptedSpJobOtherUserMessage":
        {
          chatMessage = hAcceptedJobOtherUserMessageContent;
        }
        break;

      case "AcceptedSpJobCurrentUserMessage":
        {
          chatMessage = hAcceptedJobCurrentUserMessageContent;
        }
        break;

      case "CompletedJobCurrentUserMessage":
        {
          chatMessage = hCompletedJobCurrentUserMessageContent;
        }
        break;
      case "CompletedJobOtherUserMessage":
        {
          chatMessage = hCompletedJobOtherUserMessageContent;
        }
        break;
      case "ShortListJobOtherUserMessage":
        {
          chatMessage = hShortListOtherUserMessageContent;
        }
        break;
      case "hShortListJobCurrentUserMessage":
        {
          chatMessage = hShortListCurrentUserMessageContent;
        }
        break;
      case "RewardJobCurrentUserMessage":
        {
          chatMessage = hRewardCurrentUserMessageContent;
        }
        break;
      case "RewardJobOtherUserMessage":
        {
          chatMessage = hRewardOtherUserMessageContent;
        }
        break;
      case "GigInviteCurrentUserMessage":
        {
          chatMessage = hGigInviteCurrentUserMessageContent;
        }
        break;
      case "GigInviteOtherUserMessage":
        {
          chatMessage = hGigInviteOtherUserMessageContent;
        }
        break;
      case "DeliverJobOtherUserMessage":
        {
          chatMessage = hDeliveredOtherUserMessageContent;
        }
        break;
      case "DeliverJobCurrentUserMessage":
        {
          chatMessage = hDeliveredCurrentUserMessageContent;
        }
        break;
      case "StartedJobOtherUserMessage":
        {
          chatMessage = hStartedOtherUserMessageContent;
        }
        break;
      case "StartedJobCurrentUserMessage":
        {
          chatMessage = hStartedCurrentUserMessageContent;
        }
        break;
      case "CancelledJobCurrentUserMessage":
        {
          chatMessage = hCancelCuJobCurrentUserMessageContent;
        }
        break;
      case "CancelledJobOtherUserMessage":
        {
          chatMessage = hCancelCuJobOtherUserMessageContent;
        }
        break;

      case "PaymentConfirmedCuCurrentUserMessage":
        {
          chatMessage = hPaymentConfirmedJobCurrentUserMessageContent;
        }
        break;
      case "PaymentConfirmedCuOtherUserMessage":
        {
          chatMessage = hPaymentConfirmedJobOtherUserMessageContent;
        }
        
        break;
       case "PaymentConfirmedCuOtherUserMessage1":
        {
          chatMessage = hPaymentConfirmedJobOtherUserMessageContent1;
        }
        
        break; 
      case "DISPUTECuJobCurrentUserMessage":
        {
          chatMessage = hDISPUTECuJobCurrentUserMessageContent;
        }
        break;
      case "DISPUTECuJobOtherUserMessager":
        {
          chatMessage = hDISPUTECuJobOtherUserMessageContent;
        }
        break;
      case "CuJobNotDeliveredCurrentUserMessage":
        {
          chatMessage = hJobNotDeliveredCurrentUserMessage;
        }
        break;
      case "CuJobNotDeliveredOtherUserMessage":
        {
          chatMessage = hJobNotDeliveredOtherUserMessage;
        }
        break;
      case "CuInvitedOnJobCurrentUserMessage":
        {
          chatMessage = hInviteSpOnJobCurrentUserMessageContent;
        }
        break;
      case "CuInvitedOnJobOtherUserMessage":
        {
          chatMessage = hInviteSpOnJobOtherUserMessageContent;
        }
        break;
      case "SpEditProposalOtherUserMessage":
        {
          chatMessage = hEditProposalOtherUserMessageContent;
        }
        break;
      case "SpEditProposalCurrentUserMessage":
        {
          chatMessage = hEditProposalCurrentUserMessageContent;
        }
        break;

      case "WithDrawCurrentUserMessage":
        {
          chatMessage = hWithDrawSpJobCurrentUserMessageContent;
        }
        break;
      case "WithDrawOtherUserMessage":
        {
          chatMessage = hWithDrawOtherUserMessageContent;
        }
        break;
      case "cancelSpCurrentUserMessage":
        {
          chatMessage = hCancelSpJobCurrentUserMessageContent;
        }
        break;
      case "cancelSpOtherUserMessage":
        {
          chatMessage = hCancelSpJobOtherUserMessageContent;
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
    return chatMessage;
  }
}
