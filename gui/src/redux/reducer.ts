import { createAction, AnyAction, createReducer } from "@reduxjs/toolkit";
import { wrapAction } from "../onset";
import { IWeaponDetails, IWeaponMax } from "../WeaponDetails";

// Here I create an action that takes no argument
export const setWeaponData = createAction("SET_WEAPON_DATA");

// I want this action to be available to Onset so I attach it globally
(window as any).SetWeaponData = wrapAction(setWeaponData)
export const setWeaponDetails = createAction("SET_WEAPON_DETAILS");
(window as any).SetWeaponDetails = wrapAction(setWeaponDetails)
export const setWeaponMax = createAction("SET_WEAPON_MAX");
(window as any).SetWeaponMax = wrapAction(setWeaponMax)

// Here I declare the state of my whole application
// I only have one of course because this is only counting
export interface IAppState {
    weapons: any[];
    weaponDetails?: IWeaponDetails;
    weaponsMax?: IWeaponMax;
}

const initialState: IAppState = {
    weapons: []
};

// Here it is my reducer, his tasks is to merge the future state with
export const counterReducer = createReducer(initialState, {
    [setWeaponData.type]: (state, action) => ({ ...state, weapons: JSON.parse(action.payload) }),
    [setWeaponDetails.type]: (state, action) => ({ ...state, weaponDetails: JSON.parse(action.payload) }),
    [setWeaponMax.type]: (state, action) => ({ ...state, weaponsMax: JSON.parse(action.payload) })
});
