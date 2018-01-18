package com.blaud.calls;

import android.Manifest;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.telecom.Call;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

public class Calls extends CordovaPlugin{
    public static final String READ_PHONE_STATE = Manifest.permission.READ_PHONE_STATE;

    private Call.Callback callback;
    private CallbackContext callbackContext;
    private JSONArray executeArgs;
    private PhoneStateListener listener;
    TelephonyManager telephonyManager;

    protected void getPermission(String permission, int requestCode) {
        cordova.requestPermission(this, requestCode, permission);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if(telephonyManager==null) telephonyManager = (TelephonyManager) cordova.getActivity().getSystemService(cordova.getActivity().TELEPHONY_SERVICE);
        this.callbackContext = callbackContext;
        this.executeArgs = args;

        if(action.equals("startListener")){
            if(cordova.hasPermission(READ_PHONE_STATE)){
                startListener();
            }else{
                getPermission(READ_PHONE_STATE, 0);
            }
        }else if(action.equals("stopListener")){
            stopListener();
        }

        return true;
    }

    public void onRequestPermissionResult(int requestCode, String[] permissions,
                                          int[] grantResults) throws JSONException {
        for (int r : grantResults) {
            if (r == PackageManager.PERMISSION_DENIED) {
                this.callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, 20));
                return;
            }
        }
        switch (requestCode) {
            case 0:
                startListener();
                break;
        }
    }

    public void startListener(){

        IntentFilter filter = new IntentFilter(TelephonyManager.ACTION_PHONE_STATE_CHANGED);
        CallBroadcastReceiver receiver = new CallBroadcastReceiver();
        receiver.setCallback(this.callbackContext);
        cordova.getActivity().registerReceiver(receiver, filter);

        PluginResult result = new PluginResult(PluginResult.Status.OK, "call listener started");
        result.setKeepCallback(true);
        this.callbackContext.sendPluginResult(result);
    }

    public void stopListener(){
        telephonyManager.listen(listener, PhoneStateListener.LISTEN_NONE);
        PluginResult result = new PluginResult(PluginResult.Status.OK, "call listener started");
        result.setKeepCallback(true);
        this.callbackContext.sendPluginResult(result);

        listener = null;
    }
}