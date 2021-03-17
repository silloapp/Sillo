//
//  Analytics.swift
//  Sillo
//
//  Created by William Loo on 3/16/21.
//
import Firebase
import Foundation

var analytics = EventsHandler()

class EventsHandler {
//https://firebase.google.com/docs/analytics/events?platform=ios

    //MARK: USER-RELATED
    
    //MARK: create firebase document
    func log_create_firebase_doc() {
        Analytics.logEvent("create_firebase_doc", parameters: [
            "date": Date().debugDescription as NSObject,
          "description": "a new firebase user document has been created." as NSObject
          ])
    }
    
    //MARK: create account with google
    func log_account_creation_google() {
        Analytics.logEvent("create_account_google", parameters: [
            "date": Date().debugDescription as NSObject,
          "description": "a user created account with their google education email." as NSObject
          ])
    }
    
    //MARK: sign in with google
    func log_sign_in_google() {
        Analytics.logEvent("sign_in_google", parameters: [
            "date": Date().debugDescription as NSObject,
          "description": "a user signed in with their google education email." as NSObject
          ])
    }
    
    //MARK: create account using email/password pair
    func log_account_creation_standard() {
        Analytics.logEvent("create_account_standard", parameters: [
            "date": Date().debugDescription as NSObject,
          "description": "a user created an account using email and password pair." as NSObject
          ])
    }
    
    //MARK: sign in using email/password pair
    func log_sign_in_standard() {
        Analytics.logEvent("sign_in_standard", parameters: [
            "date": Date().debugDescription as NSObject,
          "description": "a user signed in using email and password pair." as NSObject
          ])
    }
    
    //MARK: sign out
    func log_sign_out() {
        Analytics.logEvent("sign_out", parameters: [
            "date": Date().debugDescription as NSObject,
          "description": "a user signed out." as NSObject
          ])
    }
    
    //MARK: forgot password
    func log_forgot_password() {
        Analytics.logEvent("forgot_password", parameters: [
            "date": Date().debugDescription as NSObject,
          "description": "a user forgot their password and requested a reset." as NSObject
          ])
    }
    
    //MARK: passcode invokation (pending)
    func log_passcode_verification_request() {
        Analytics.logEvent("passcode_verification_request", parameters: [
          "date": Date().debugDescription as NSObject,
          "description": "a verification passcode has been sent to a user via sendgrid email." as NSObject
          ])
    }
    
    //MARK: passcode resent (pending)
    func log_passcode_verification_resend() {
        Analytics.logEvent("passcode_verification_resend", parameters: [
          "date": Date().debugDescription as NSObject,
          "description": "a verification passcode has been resent to a user via sendgrid email." as NSObject
          ])
    }
    
    //MARK: passcode verfification was successful
    func log_passcode_verification_success() {
        Analytics.logEvent("passcode_verification_success", parameters: [
          "date": Date().debugDescription as NSObject,
          "description": "a user has successfully verfied using passcode." as NSObject
          ])
    }
    
    //MARK: notifications enabled
    func log_notifications_enabled() {
        Analytics.logEvent("notifications_enabled", parameters: [
          "date": Date().debugDescription as NSObject,
          "description": "a user has enabled notifications" as NSObject
          ])
    }
    
    
    //MARK: PROFILE-RELATED
    
    //MARK: create profile
    func log_create_profile() {
        Analytics.logEvent("create_profile", parameters: [
            "organization": organizationData.currOrganizationName! as NSObject,
            "date": Date().debugDescription as NSObject,
          "description": "a new profile has been created." as NSObject
          ])
    }
    
    //MARK: edit profile
    func log_edit_profile() {
        Analytics.logEvent("edit_profile", parameters: [
            "organization": organizationData.currOrganizationName! as NSObject,
            "date": Date().debugDescription as NSObject,
          "description": "edit profile." as NSObject
          ])
    }
    
    
    //MARK: POSTING-RELATED
    
    //MARK: create post
    func log_create_post() {
        Analytics.logEvent("create_post", parameters: [
            "organization": organizationData.currOrganizationName! as NSObject,
            "date": Date().debugDescription as NSObject,
          "description": "a post has been created." as NSObject
          ])
    }
    
    //MARK: CHATTING-RELATED
    
    //MARK: create chat conversation
    func log_create_chat() {
        Analytics.logEvent("create_chat", parameters: [
            "organization": organizationData.currOrganizationName! as NSObject,
            "date": Date().debugDescription as NSObject,
          "description": "a chat conversation has been created." as NSObject
          ])
    }
    
    //MARK: chat message sent
    func log_send_chat_message() {
        Analytics.logEvent("create_chat_message", parameters: [
            "organization": organizationData.currOrganizationName! as NSObject,
            "date": Date().debugDescription as NSObject,
          "description": "a chat message has been created and sent." as NSObject
          ])
    }
    
    //MARK: new reveal
    func log_reveal() {
        Analytics.logEvent("reveal", parameters: [
            "organization": organizationData.currOrganizationName! as NSObject,
            "date": Date().debugDescription as NSObject,
          "description": "a user has revealed themselves." as NSObject
          ])
    }
    
}
