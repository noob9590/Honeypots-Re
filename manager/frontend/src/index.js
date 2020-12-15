import React from "react";
import ReactDOM from "react-dom";
import "@fortawesome/fontawesome-free/css/all.min.css";
import "bootstrap-css-only/css/bootstrap.min.css";
import "mdbreact/dist/css/mdb.css";
import "./index.css";
import AppClear from "./App-clear";

import registerServiceWorker from "./registerServiceWorker";

// if you want to see demo app, change <AppClear/> to <App />
ReactDOM.render(<AppClear />, document.getElementById("root"));

registerServiceWorker();
