import React from "react";
import { useSelector } from "react-redux";
import { IAppState } from "./redux/reducer";
import { IWeaponItem, WeaponItem } from "./WeaponItem";

export const Weapons: React.FC = () => {
    const weapons = useSelector((state: IAppState) => state.weapons);
    console.log(weapons);
    return (
        <div id="selectionContainer">
            {
                weapons.map((weapon: IWeaponItem) => <WeaponItem {...weapon} />)
            }
      </div>
    )
}
