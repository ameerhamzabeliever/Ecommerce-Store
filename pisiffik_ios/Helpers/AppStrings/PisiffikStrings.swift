//
//  PisiffikStrings.swift
//  pisiffik_ios
//
//  Created by Haider Ali on 27/05/2022.
//  Copyright © 2022 softwareAlliance. All rights reserved.
//

import Foundation
import Localize_Swift

struct PisiffikStrings{
    
    // MARK: - COMMON -
    
    static func somethingWentWron() -> String {
        return "errorSomethingWrong".localized()
    }
    
    static func tryAgain() -> String{
        return "tryAgain".localized()
    }
    
    static func makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain() -> String{
        return "makeSureWifiOrCellularDataIsTurnedOnAndThenTrySgain".localized()
    }
    
    static func oopsNoInternetConnection() -> String{
        return "oopsNoInternetConnection".localized()
    }
    
    static func somethingWentWrong() -> String{
        return "somethingWentWrong".localized()
    }
    
    static func sorryNoItemFound() -> String{
        return "sorryNoItemFound".localized()
    }
    
    static func sessionExpired() -> String{
        return "sessionExpired".localized()
    }
    
    //MARK: - VALIDATIONS -
    
    static func mobileNumberRequired() -> String{
        return "mobileNumberRequired".localized()
    }
    
    static func enterValidNumber() -> String{
        return "enterValidNumber".localized()
    }
    
    static func passwordMustRequired() -> String{
        return "passwordMustRequired".localized()
    }
    
    static func passwordShouldBe6Characters() -> String{
        return "passwordShouldBe6Characters".localized()
    }
    
    static func confirmPasswordMustRequired() -> String{
        return "confirmPasswordMustRequired".localized()
    }
    
    static func confirmPasswordShouldBe6Characters() -> String{
        return "confirmPasswordShouldBe6Characters".localized()
    }
    
    static func bothPasswordMustBeMatched() -> String{
        return "bothPasswordMustBeMatched".localized()
    }
    
    static func deviceTypeRequired() -> String{
        return "deviceTypeRequired".localized()
    }
    
    static func fcmTokenRequired() -> String{
        return "fcmTokenRequired".localized()
    }
    
    
    //MARK: - LANGUAGE -
    
    static func _continue() -> String{
        return "continue".localized()
    }
    
    static func pleaseSelectYourLanguage() -> String{
        return "pleaseSelectYourLanguage".localized()
    }
    
    static func danish() -> String{
        return "danish".localized()
    }
    
    static func greenland() -> String{
        return "greenland".localized()
    }
    
    static func english() -> String{
        return "english".localized()
    }
    
    static func alert() -> String{
        return "alert".localized()
    }
    
    
    //MARK: - AUTH BOARD -
    
    //MARK: - LOGIN VC -
    
    static func next() -> String{
        return "next".localized()
    }
    
    static func loginYourAccount() -> String{
        return "loginYourAccount".localized()
    }
    
    static func mobileNumber() -> String{
        return "mobileNumber".localized()
    }
    
    static func password() -> String{
        return "password".localized()
    }
    
    static func forgotPassword() -> String{
        return "forgotPassword".localized()
    }
    
    static func login() -> String{
        return "login".localized()
    }
    
    static func notRegisterYetCreateAnAccount() -> String{
        return "notRegisterYetCreateAnAccount".localized()
    }
    
    static func bySignInYouAgreeToPisiffik() -> String{
        return "bySignInYouAgreeToPisiffik".localized()
    }
    
    static func bySignUpYouAgreeToPisiffik() -> String{
        return "bySignUpYouAgreeToPisiffik".localized()
    }
    
    static func termsOfUse() -> String{
        return "termsOfUse".localized()
    }
    
    static func _and() -> String{
        return "_and".localized()
    }
    
    static func privacyPolicy() -> String{
        return "privacyPolicy".localized()
    }
    
    static func enableAccessToCalenderMessage() -> String{
        return "enableAccessToCalenderMessage".localized()
    }
    
    static func at() -> String{
        return "at".localized()
    }
   
    static func or() -> String{
        return "or".localized()
    }
   
    static func pleaseTypePhoneNmbOrEmailError() -> String{
        return "pleaseTypePhoneNmbOrEmailError".localized()
    }
    
    //MARK: - SIGNUP -
    
    static func joinPisiffik() -> String{
        return "joinPisiffik".localized()
    }
    
    static func fullName() -> String{
        return "fullName".localized()
    }
    
    static func and() -> String{
        return "and".localized()
    }
    
    static func alreadyAMemberLogin() -> String{
        return "alreadyAMemberLogin".localized()
    }
    
    //MARK: - VERIFICATION -
    
    static func verifyPhone() -> String{
        return "verifyPhone".localized()
    }
    
    static func enterVerificationCode() -> String{
        return "enterVerificationCode".localized()
    }
    
    static func weHaveSentToYourMobileNumber() -> String{
        return "weHaveSentToYourMobileNumber".localized()
    }
    
    static func weHaveSentToYourEmailAddress() -> String{
        return "weHaveSentToYourEmailAddress".localized()
    }
    
    static func weHaveSentToYourEmail() -> String{
        return "weHaveSentToYourEmail".localized()
    }
    
    static func verify() -> String{
        return "verify".localized()
    }
    
    static func didNotGetACode() -> String{
        return "didNotGetACode".localized()
    }
    
    static func resend() -> String{
        return "resend".localized()
    }
    
    static func pleaseEnterValidOtpCodeForVerification() -> String{
        return "pleaseEnterValidOtpCodeForVerification".localized()
    }
    
    static func newPhoneIsRequired() -> String{
        return "newPhoneIsRequired".localized()
    }
    
    static func newPhoneIsInValid() -> String{
        return "newPhoneIsInValid".localized()
    }
    
    static func newEmailIsRequired() -> String{
        return "newEmailIsRequired".localized()
    }
    
    static func newEmailIsInValid() -> String{
        return "newEmailIsInValid".localized()
    }
    
    //MARK: - VERIFYING VC -
    
    static func verifying() -> String{
        return "verifying".localized()
    }
    
    static func ok() -> String{
        return "ok".localized()
    }
    
    //MARK: - FORGOT PASSWORD -
    
    static func forgot_Password() -> String{
        return "forgot_Password".localized()
    }
    
    static func enterYourMobileNumberToResetPassword() -> String{
        return "enterYourMobileNumberToResetPassword".localized()
    }
    
    //MARK: - RESET PASSWORD -
    
    static func resetYourPassword() -> String{
        return "resetYourPassword".localized()
    }
    
    static func newPassword() -> String{
        return "newPassword".localized()
    }
    
    static func confirmPassword() -> String{
        return "confirmPassword".localized()
    }
    
    static func mustBeAtLeastSixCharacters() -> String{
        return "mustBeAtLeastSixCharacters".localized()
    }
    
    static func resetPassword() -> String{
        return "resetPassword".localized()
    }
    
    static func enterValidFullName() -> String{
        return "enterValidFullName".localized()
    }
    
    static func enterValidFullNameWithoutNumber() -> String{
        return "enterValidFullNameWithoutNumber".localized()
    }
    
    static func fullNameRequired() -> String{
        return "fullNameRequired".localized()
    }
    
    static func fullNameLenghtError() -> String{
        return "fullNameLenghtError".localized()
    }
    
    static func success() -> String{
        return "success".localized()
    }
    
    static func selectDateOfBirth() -> String{
        return "selectDateOfBirth".localized()
    }
    
    static func selectYourGender() -> String{
        return "selectYourGender".localized()
    }
    
    static func emailRequired() -> String{
        return "emailRequired".localized()
    }
    
    static func enterValidEmail() -> String{
        return "enterValidEmail".localized()
    }
    
    static func alreadyVerifiedEmail() -> String{
        return "alreadyVerifiedEmail".localized()
    }
    
    
    //MARK: - ADD TICKET VALIDATION -

    static func reasonRequired() -> String{
        return "reasonRequired".localized()
    }
    
    static func subjectRequired() -> String{
        return "subjectRequired".localized()
    }
    
    static func messageRequired() -> String{
        return "messageRequired".localized()
    }

    
    //MARK: - MAIN TABBAR -
    
    static func hi() -> String {
        return "hi".localized()
    }
    
    static func home() -> String{
        return "home".localized()
    }
    
    static func offers() -> String{
        return "offers".localized()
    }
    
    static func online() -> String{
        return "online".localized()
    }
    
    static func more() -> String{
        return "more".localized()
    }
    
    static func store() -> String{
        return "store".localized()
    }
    
    static func scan() -> String{
        return "scan".localized()
    }
    
    static func currentOffers() -> String{
        return "currentOffers".localized()
    }
    
    static func currentCampaigns() -> String{
        return "currentCampaigns".localized()
    }
    
    static func campaignProducts() -> String{
        return "campaignProducts".localized()
    }
    
    static func viewDetail() -> String{
        return "viewDetail".localized()
    }
    
    static func pointsOverview() -> String{
        return "pointsOverview".localized()
    }
    
    static func seeAll() -> String{
        return "seeAll".localized()
    }
    
    static func recipes() -> String{
        return "recipes".localized()
    }
    
    static func by() -> String{
        return "by".localized()
    }
    
    static func serving() -> String{
        return "serving".localized()
    }
    
    static func portions() -> String{
        return "portions".localized()
    }
    
    static func time() -> String{
        return "time".localized()
    }
    
    static func min() -> String{
        return "min".localized()
    }
    
    static func person() -> String{
        return "person".localized()
    }
    
    static func quantity() -> String{
        return "quantity".localized()
    }
    
    static func seeMore() -> String{
        return "seeMore".localized()
    }
    
    //MARK: - PROFILE TAB VC -
    
    static func profile() -> String{
        return "profile".localized()
    }
    
    static func inbox() -> String{
        return "inbox".localized()
    }
    
    static func purchase() -> String{
        return "purchase".localized()
    }
    
    static func favorites() -> String{
        return "favorites".localized()
    }
    
    static func offersAndBenefits() -> String{
        return "offersAndBenefits".localized()
    }
    
    static func preferences() -> String{
        return "preferences".localized()
    }
    
    static func customerService() -> String{
        return "customerService".localized()
    }
    
    static func aboutPisiffik() -> String{
        return "aboutPisiffik".localized()
    }
    
    static func termsAndConditions() -> String{
        return "termsAndConditions".localized()
    }
    
    static func rateOurApp() -> String{
        return "rateOurApp".localized()
    }
    
    static func gdpr() -> String{
        return "gdpr".localized()
    }
    
    static func logout() -> String{
        return "logout".localized()
    }
    
    //MARK: - CUSTOMER SUPPORT SERVICE -

    static func contactUs() -> String{
        return "contactUs".localized()
    }
    
    static func youCanContactUs() -> String{
        return "youCanContactUs".localized()
    }
    
    static func forMoreInformation() -> String{
        return "forMoreInformation".localized()
    }
    
    static func seeFAQ() -> String{
        return "seeFAQ".localized()
    }
    
    static func faq() -> String{
        return "faq".localized()
    }
    
    static func seeTheRelevantTopic() -> String{
        return "seeTheRelevantTopic".localized()
    }
    
    static func contactToCustomerServiceCenter() -> String{
        return "contactToCustomerServiceCenter".localized()
    }
    
    static func clickHere() -> String{
        return "clickHere".localized()
    }
    
    static func order() -> String{
        return "order".localized()
    }
    
    static func product() -> String{
        return "product".localized()
    }
    
    static func payment() -> String{
        return "payment".localized()
    }
    
    static func otherQueries() -> String{
        return "otherQueries".localized()
    }
    
    static func search() -> String{
        return "search".localized()
    }
    
    static func reason() -> String{
        return "reason".localized()
    }
    
    static func subject() -> String{
        return "subject".localized()
    }
    
    static func description() -> String{
        return "description".localized()
    }
    
    static func send() -> String{
        return "send".localized()
    }
    
    static func thankYouForContactingUs() -> String{
        return "thankYouForContactingUs".localized()
    }
    
    static func pisiffikRepresentativeWillRespondToYourQuerySoon() -> String{
        return "pisiffikRepresentativeWillRespondToYourQuerySoon".localized()
    }
    
    //MARK: - MY FAVORITES -

    static func pisiffikItems() -> String{
        return "pisiffikItems".localized()
    }
    
    static func otherItems() -> String{
        return "otherItems".localized()
    }
    
    //MARK: - MY PROFILE VC -
    
    static func email() -> String{
        return "email".localized()
    }
    
    static func emailPlaceHolder() -> String{
        return "emailPlaceHolder".localized()
    }
    
    static func verifyEmail() -> String{
        return "verifyEmail".localized()
    }
    
    static func verified() -> String{
        return "verified".localized()
    }
    
    static func dateOfBirth() -> String{
        return "dateOfBirth".localized()
    }
    
    static func gender() -> String{
        return "gender".localized()
    }
    
    static func country() -> String{
        return "country".localized()
    }
    
    static func state() -> String{
        return "state".localized()
    }
    
    static func city() -> String{
        return "city".localized()
    }
    
    static func address() -> String{
        return "address".localized()
    }
    
    static func select() -> String{
        return "select".localized()
    }
    
    static func update() -> String{
        return "update".localized()
    }
    
    static func male() -> String{
        return "male".localized()
    }
    
    static func female() -> String{
        return "female".localized()
    }
    
    static func cancel() -> String{
        return "cancel".localized()
    }
    
    static func done() -> String{
        return "done".localized()
    }
    
    //MARK: - INBOX VC -
    
    static func news() -> String{
        return "news".localized()
    }
    
    static func events() -> String{
        return "events".localized()
    }
    
    static func notifications() -> String{
        return "notifications".localized()
    }
    
    static func days() -> String{
        return "days".localized()
    }
    
    static func direction() -> String{
        return "direction".localized()
    }
    
    static func km() -> String{
        return "km".localized()
    }
    
    static func tickets() -> String{
        return "tickets".localized()
    }
    
    static func ticket() -> String{
        return "ticket".localized()
    }
    
    static func eventDetails() -> String{
        return "eventDetails".localized()
    }
    
    static func validFrom() -> String{
        return "validFrom".localized()
    }
    
    static func offerNewspapers() -> String{
        return "offerNewspapers".localized()
    }
    
    static func personalOffers() -> String{
        return "personalOffers".localized()
    }
    
    static func membershipOffers() -> String{
        return "membershipOffers".localized()
    }
    
    static func localOffers() -> String{
        return "localOffers".localized()
    }
    
    static func eventActivities() -> String{
        return "eventActivities".localized()
    }
    
    static func attachFile() -> String{
        return "attachFile".localized()
    }
    
    static func attacments() -> String{
        return "attacments".localized()
    }
    
    static func photo() -> String{
        return "photo".localized()
    }
    
    static func document() -> String{
        return "document".localized()
    }
    
    static func fromDocuments() -> String{
        return "fromDocuments".localized()
    }
    
    static func fromGallery() -> String{
        return "fromGallery".localized()
    }
    
    static func viewFile() -> String{
        return "viewFile".localized()
    }
    
    static func status() -> String{
        return "status".localized()
    }
    
    static func open() -> String{
        return "open".localized()
    }
    
    static func closed() -> String{
        return "closed".localized()
    }
    
    static func pending() -> String{
        return "pending".localized()
    }
    
    static func reOpened() -> String{
        return "reOpened".localized()
    }
    
    static func youCanOnlSelectMaximum() -> String{
        return "youCanOnlSelectMaximum".localized()
    }
    
    static func youCanOnlySendMaximum() -> String{
        return "youCanOnlySendMaximum".localized()
    }
    
    static func mb() -> String{
        return "mb".localized()
    }
    
    static func fileSize() -> String{
        return "fileSize".localized()
    }
    
    static func enableLocationStoreDirectionAlertMessage() -> String{
        return "enableLocationStoreDirectionAlertMessage".localized()
    }
    
    static func enableLocationStoreDistanceAlertMessage() -> String{
        return "enableLocationStoreDistanceAlertMessage".localized()
    }
    
    static func oopsStoreDirectionNotAvailable() -> String{
        return "oopsStoreDirectionNotAvailable".localized()
    }
    
    static func cameraPermissionNeeded() -> String{
        return "cameraPermissionNeeded".localized()
    }
    
    static func eventAddedToCalender() -> String{
        return "eventAddedToCalender".localized()
    }
    
    static func eventRemovedToCalender() -> String{
        return "eventRemovedToCalender".localized()
    }
    
    static func ticketClosedError() -> String{
        return "ticketClosedError".localized()
    }
    
    static func rebate() -> String{
        return "rebate".localized()
    }
    
    //MARK: - MY PURCHASES VC -
    
    static func allPurchases() -> String{
        return "allPurchases".localized()
    }
    
    static func boughtInPisiffikWebshop() -> String{
        return "boughtInPisiffikWebshop".localized()
    }
    
    static func boughtInPisiffikStore() -> String{
        return "boughtInPisiffikStore".localized()
    }
    
    static func all() -> String{
        return "all".localized()
    }
    
    static func lastSixMonths() -> String{
        return "lastSixMonths".localized()
    }
    
    static func save() -> String{
        return "save".localized()
    }
    
    static func orderNo() -> String{
        return "orderNo".localized()
    }
    
    static func orderDate() -> String{
        return "orderDate".localized()
    }
    
    static func amount() -> String{
        return "amount".localized()
    }
    
    static func redeemPoints() -> String{
        return "redeemPoints".localized()
    }
    
    static func youHaveEarned() -> String{
        return "youHaveEarned".localized()
    }
    
    static func pisiffikBenefits() -> String{
        return "pisiffikBenefits".localized()
    }
    
    static func deliveryTo() -> String{
        return "deliveryTo".localized()
    }
    
    static func whenYourOrderIsCompletedSuccessfully() -> String{
        return "whenYourOrderIsCompletedSuccessfully".localized()
    }
    
    static func cancelOrder() -> String{
        return "cancelOrder".localized()
    }
    
    
    static func delivered() -> String{
        return "delivered".localized()
    }
    
    static func readyForPickup() -> String{
        return "readyForPickup".localized()
    }
    
    static func sentToStore() -> String{
        return "sentToStore".localized()
    }
    
    static func duringTreatment() -> String{
        return "duringTreatment".localized()
    }
    
    static func received() -> String{
        return "received".localized()
    }
    
    static func packageNumber() -> String{
        return "packageNumber".localized()
    }
    
    static func areYouSureYouWantToCancelThisOrder() -> String{
        return "areYouSureYouWantToCancelThisOrder".localized()
    }
    
    //MARK: - CANCEL ORDER VC -

    static func cancellationRequest() -> String{
        return "cancellationRequest".localized()
    }
    
    static func orderInfo() -> String{
        return "orderInfo".localized()
    }
    
    static func cancelOrderDescription() -> String{
        return "cancelOrderDescription".localized()
    }
    
    static func reasonForCancellation() -> String{
        return "reasonForCancellation".localized()
    }
    
    static func confirmCancellationRequest() -> String{
        return "confirmCancellationRequest".localized()
    }
    
    static func requestSent() -> String{
        return "requestSent".localized()
    }
    
    static func yourItemsHasBeenPlacedAndIsOnItWayToBeingProcessed() -> String{
        return "yourItemsHasBeenPlacedAndIsOnItWayToBeingProcessed".localized()
    }
    
    //MARK: - MY POINTS VC -
    
    static func availablePoints() -> String{
        return "availablePoints".localized()
    }
    
    static func yourPointsExpireSoon() -> String{
        return "yourPointsExpireSoon".localized()
    }
    
    static func outOf() -> String{
        return "outOf".localized()
    }
    
    static func expiresOn() -> String{
        return "expiresOn".localized()
    }
    
    static func expireIn() -> String{
        return "expireIn".localized()
    }
    
    static func earned() -> String{
        return "earned".localized()
    }
    
    static func redeem() -> String{
        return "redeem".localized()
    }
    
    static func expire() -> String{
        return "expire".localized()
    }
    
    static func recent() -> String{
        return "recent".localized()
    }
    
    static func thisWeek() -> String{
        return "thisWeek".localized()
    }
    
    static func thisMonth() -> String{
        return "thisMonth".localized()
    }
    
    static func thisYear() -> String{
        return "thisYear".localized()
    }
    
    static func date() -> String{
        return "date".localized()
    }
    
    static func earnedPoints() -> String{
        return "earnedPoints".localized()
    }
    
    static func points() -> String{
        return "points".localized()
    }
    
    static func expired() -> String{
        return "expired".localized()
    }
    
    //MARK: - FIND STORE -
    
    static func findStore() -> String{
        return "findStore".localized()
    }
    
    //MARK: - STORE VC -
    
    static func scanBarcode() -> String{
        return "scanBarcode".localized()
    }
    
    static func getHelpWithScan() -> String{
        return "getHelpWithScan".localized()
    }
    
    static func error() -> String{
        return "error".localized()
    }
    
    static func instructions() -> String{
        return "instructions".localized()
    }
    
    static func scanBarcodeAndGetProductDetailsLikeProductNameBrandPricing() -> String{
        return "scanBarcodeAndGetProductDetailsLikeProductNameBrandPricing".localized()
    }
    
    static func okay() -> String{
        return "okay".localized()
    }
    
    static func myMembershipCard() -> String{
        return "myMembershipCard".localized()
    }
    
    static func scanningNotSupported() -> String{
        return "scanningNotSupported".localized()
    }
    
    static func yourDeviceDoesNotSupportScanningaCodeFromAnItemPleaseUseADeviceWithACamera() -> String{
        return "yourDeviceDoesNotSupportScanningaCodeFromAnItemPleaseUseADeviceWithACamera".localized()
    }
    
    //MARK: - RECIPES VC -
    
    static func breakfast() -> String{
        return "breakfast".localized()
    }
    
    static func lunch() -> String{
        return "lunch".localized()
    }
    
    static func dinner() -> String{
        return "dinner".localized()
    }
    
    static func addToShoppingList() -> String{
        return "addToShoppingList".localized()
    }
    
    static func ingrediants() -> String{
        return "ingrediants".localized()
    }
    
    static func items() -> String{
        return "items".localized()
    }
    
    static func qty() -> String{
        return "qty".localized()
    }
    
    static func courseOfAction() -> String{
        return "courseOfAction".localized()
    }
    
    static func tip() -> String{
        return "tip".localized()
    }
    
    static func selectProductsFromIngredients() -> String{
        return "selectProductsFromIngredients".localized()
    }
    
    //MARK: - OFFER DETAIL VC -
    
    static func details() -> String{
        return "details".localized()
    }
    
    static func addToCart() -> String{
        return "addToCart".localized()
    }
    
    static func singlePurchase() -> String{
        return "singlePurchase".localized()
    }
    
    static func inStock() -> String{
        return "inStock".localized()
    }
    
    static func youWillEarn() -> String{
        return "youWillEarn".localized()
    }
    
    static func youWillSpent() -> String{
        return "youWillSpent".localized()
    }
    
    static func andGetRebate() -> String{
        return "andGetRebate".localized()
    }
    
    static func pointsAtPisiffik() -> String{
        return "pointsAtPisiffik".localized()
    }
    
    static func atPisiffik() -> String{
        return "atPisiffik".localized()
    }
    
    static func availableAtStores() -> String{
        return "availableAtStores".localized()
    }
    
    static func info() -> String{
        return "info".localized()
    }
    
    static func specification() -> String{
        return "specification".localized()
    }
    
    static func myShoppingList() -> String{
        return "myShoppingList".localized()
    }
    
    static func openingHours() -> String{
        return "openingHours".localized()
    }
    
    //MARK: - CART VC -
    
    static func myCart() -> String{
        return "myCart".localized()
    }
    
    static func goToCheckout() -> String{
        return "goToCheckout".localized()
    }
    
    static func checkoutToEarn() -> String{
        return "checkoutToEarn".localized()
    }
    
    static func checkout() -> String{
        return "checkout".localized()
    }
    
    static func loyaltyAndDiscounts() -> String{
        return "loyaltyAndDiscounts".localized()
    }
    
    static func reedemAll() -> String{
        return "reedemAll".localized()
    }
    
    static func totalVAT() -> String{
        return "totalVAT".localized()
    }
    
    static func deliveryFee() -> String{
        return "deliveryFee".localized()
    }
    
    static func free() -> String{
        return "free".localized()
    }
    
    static func reedemPoints() -> String{
        return "reedemPoints".localized()
    }
    
    static func totalAmountDue() -> String{
        return "totalAmountDue".localized()
    }
    
    static func deliveryAddress() -> String{
        return "deliveryAddress".localized()
    }
    
    static func addNewAddress() -> String{
        return "addNewAddress".localized()
    }
    
    static func paymentMethod() -> String{
        return "paymentMethod".localized()
    }
    
    static func slideToOrder() -> String{
        return "slideToOrder".localized()
    }
    
    static func selectOne() -> String{
        return "selectOne".localized()
    }
    
    static func delivery() -> String{
        return "delivery".localized()
    }
    
    static func schedule() -> String{
        return "schedule".localized()
    }
    
    static func apply() -> String{
        return "apply".localized()
    }
    
    static func cashOnDelivery() -> String{
        return "cashOnDelivery".localized()
    }
    
    static func creditOrDabitCard() -> String{
        return "creditOrDabitCard".localized()
    }
    
    static func noCardsAdded() -> String{
        return "noCardsAdded".localized()
    }
    
    static func addACardToEnjoyASeamlessPaymentsExperience() -> String{
        return "addACardToEnjoyASeamlessPaymentsExperience".localized()
    }
    
    static func cardNumber() -> String{
        return "cardNumber".localized()
    }
    
    static func cardNo() -> String{
        return "cardNo".localized()
    }
    
    static func expiryMonth() -> String{
        return "expiryMonth".localized()
    }
    
    static func expiryYear() -> String{
        return "expiryYear".localized()
    }
    
    static func cvv() -> String{
        return "cvv".localized()
    }
    
    static func saveCard() -> String{
        return "saveCard".localized()
    }
    
    static func addNewCard() -> String{
        return "addNewCard".localized()
    }
    
    static func nameOnCard() -> String{
        return "nameOnCard".localized()
    }
    
    static func defaultAddress() -> String{
        return "defaultAddress".localized()
    }
    
    static func additionalAddresses() -> String{
        return "additionalAddresses".localized()
    }
    
    static func editAddress() -> String{
        return "editAddress".localized()
    }
    
    static func type() -> String{
        return "type".localized()
    }
    
    static func office() -> String{
        return "office".localized()
    }
    
    static func other() -> String{
        return "other".localized()
    }
    
    static func optional() -> String{
        return "optional".localized()
    }
    
    static func saveChanges() -> String{
        return "saveChanges".localized()
    }
    
    static func pointsToBeUsed() -> String{
        return "pointsToBeUsed".localized()
    }
    
    static func pointsToBeEarned() -> String{
        return "pointsToBeEarned".localized()
    }
    
    //MARK: - MY OFFER AND BENEFIT VC -

    static func personal() -> String{
        return "personal".localized()
    }
    
    static func local() -> String{
        return "local".localized()
    }
    
    static func membership() -> String{
        return "membership".localized()
    }
    
    static func concept() -> String{
        return "concept".localized()
    }
    
    static func allOffers() -> String{
        return "allOffers".localized()
    }
    
    //MARK: - DELETE ALERT VC -

    static func deleteAddress() -> String{
        return "deleteAddress".localized()
    }
    
    static func areYouSureYouWantToDeleteThisAddress() -> String{
        return "areYouSureYouWantToDeleteThisAddress".localized()
    }
    
    static func yes() -> String{
        return "yes".localized()
    }
    
    static func no() -> String{
        return "no".localized()
    }
    
    //MARK: - PREFERENCES -
    
    static func categories() -> String{
        return "categories".localized()
    }
    
    static func electronics() -> String{
        return "electronics".localized()
    }
    
    static func interiorDesign() -> String{
        return "interiorDesign".localized()
    }
    
    static func hardware() -> String{
        return "hardware".localized()
    }
    
    static func toysLeisure() -> String{
        return "toysLeisure".localized()
    }
    
    static func outdoor() -> String{
        return "outdoor".localized()
    }
    
    static func womenClothing() -> String{
        return "womenClothing".localized()
    }
    
    static func vinnit() -> String{
        return "vinnit".localized()
    }
    
    
}
