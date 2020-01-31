import {store} from "./redux/store";
import { AnyAction } from "@reduxjs/toolkit";



/**
 * You should not edit this file this is the function to dispatch actions to the store
 * outside of a react component
 */
type ForeignAction = (...args: any[]) => AnyAction;
export const wrapAction = (fn: ForeignAction) => (...args: any[]) => store.dispatch(fn(...args));


const ue = (window as any).ue;
if (typeof ue !== 'undefined') //If we're running game
    {
        (function(obj)
        {
            ue.game = {};
            ue.game.callevent = function(name: any, ...args: any[])
            {
                if (typeof name != "string") {
                    return;
                }
    
                if (args.length == 0) {
                    obj.callevent(name, "")
                }
                else {
                    let params = []
                    for (let i = 0; i < args.length; i++) {
                        params[i] = args[i];
                    }
                    obj.callevent(name, JSON.stringify(params));
                }
            };
        })(ue.game);
        (window as any).CallEvent = ue.game.callevent;
    }
    else //If we're running in Browser
    {
        (window as any).CallEvent = function() {}; //Define CallEvent to prevent errors.
    }