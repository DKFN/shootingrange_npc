import React, { useEffect } from "react";

export interface IWeaponItem {
    model: number;
    type: number;
    id: number;
    name: string;
}

const getWeaponTypeName = (weaponType: number) => {
    if (weaponType === 1) return "Pistolet"
    if (weaponType === 2) return "SMG"
    if (weaponType === 3) return "Fusil a pompe"
    if (weaponType === 4) return "Fusil"
    return "Inconnu"
}

export const WeaponItem: React.FC<IWeaponItem> = (props: IWeaponItem) => {

    const onClick = () => {
        (window as any).CallEvent('AskWeaponDetails', props.id) 
    }

    return (
        <div className="weaponItem" onClick={onClick}>
            <div><h2>{props.name}</h2></div>
            <div><img src={`http://game/objects/${props.model}.jpg`} width={42}/></div>
            <div>{getWeaponTypeName(props.type)}</div>
        </div>
    )
}
