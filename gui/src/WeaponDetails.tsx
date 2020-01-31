import React from "react"
import { useSelector } from "react-redux";
import { IAppState } from "./redux/reducer";
import { REPL_MODE_STRICT } from "repl";

export interface IWeaponDetails {
    id: number;
    Name: string;
    Damage: number;
    MagazineSize: number;
    Recoil: number;
    Range: number;
    RateOfFire: number;
    model: string;
}

export interface IWeaponMax {
    MagazineSize: number;
    RateOfFire: number;
    Range: number;
}

export const WeaponDetails = () => {
    const weaponDetails = useSelector((appState: IAppState) => appState.weaponDetails);
    const weaponMax = useSelector((appState: IAppState) => appState.weaponsMax);

    console.log("Details ? ", weaponDetails);
    console.log("Max info ? ", weaponMax);

    const content = weaponDetails 
        ? <div style={{display: 'flex', justifyContent: 'space-between'}}>
            <div>
                <b><h2>{weaponDetails.Name}</h2></b>
                <div className="weapon-image">
                    <img src={`http://game/objects/${weaponDetails.model}.jpg`} />
                </div>
                <div className="weaponTryButton">
                    <button className="button is-success" onClick={() => {
                        (window as any).CallEvent("AskTryWeapon", weaponDetails.id)
                    }}>
                        ESSAYER L'ARME
                    </button>
                </div>
            </div>
            <div>
                { weaponDetails && weaponMax && (
                    <div style={{width: '100%', marginLeft: 10, minWidth: 200}}>
                        Portée : <progress className="progress is-warning" value={weaponDetails.Range} max={weaponMax.Range}>e</progress>
                        Taille du chargeur : <progress className="progress is-warning" value={weaponDetails.MagazineSize} max={weaponMax.MagazineSize}>e</progress>
                        Vitesse de feu : <progress className="progress is-warning" value={weaponDetails.RateOfFire} max={weaponMax.RateOfFire}>e</progress>
                    </div>)
                }
            </div>
        </div>
        : <b><h2>Selectionnez une arme pour voir les details</h2></b>;
    return (
        <div style={{
            textAlign: 'center'
        }}>
            {content}
        </div>
    )
}
