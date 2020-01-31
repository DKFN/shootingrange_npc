import React from 'react';
import './App.css';
import { Provider } from 'react-redux';
import {store} from "./redux/store";
import { WeaponItem } from './WeaponItem';
import { Weapons } from './Weapons';
import { WeaponDetails } from './WeaponDetails';

// This is the main part of the application that will run as soon as the cef is ready and javascript loaded
const App: React.FC = () => {
  return (
    <Provider store={store}>
      <div className="ogk-shadowbox">
        <h1>ARMED AND DANGEROUS</h1><br />br />
        <span className="pull-right">Appuyez [F4] ou [ESC] pour quitter</span>
        <div  id="boxContainer">
          <Weapons />
          <WeaponDetails />
        </div>
      </div>
    </Provider>
  );
}

export default App;
