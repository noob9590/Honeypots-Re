import React, { useEffect, useState } from 'react';
import { MDBContainer, MDBDataTableV5 } from 'mdbreact';
import { io } from "socket.io-client";
import { useAuth } from './context/auth'
import '../table.css'
function TopSearch() {
  const { authTokens } = useAuth()
  const [alert, setAlert] = useState([])
  const test = {
    honeypotName: "test",
    eventId: "test",
    ipAdress: "test",
    workstation: "test",
    date: "test",
    username: "test",
  }
  const [datatable, setDatatable] = React.useState({
    columns: [
      {
        label: 'Honeypot Name',
        field: 'honeypotName',
        width: 150,
        attributes: {
          'aria-controls': 'DataTable',
          'aria-label': 'Name',
        },
      },
      {
        label: 'Event identifier',
        field: 'eventId',
        width: 270,
      },
      {
        label: 'IP Address',
        field: 'ipAddress',
        width: 200,
      },
      {
        label: 'Workstation',
        field: 'workstation',
        sort: 'asc',
        width: 100,
      },
      {
        label: 'Start date',
        field: 'date',
        sort: 'disabled',
        width: 250,
      },
      {
        label: 'Username',
        field: 'username',
        sort: 'disabled',
        width: 100,
      },
      {
        label: 'Details',
        field: 'details',
        sort: 'diabled',
        width: 100
      }
    ],
    rows: [],
  });





  return (
    <MDBContainer className="text-center" fluid>
      <MDBDataTableV5 hover entriesOptions={[5, 20, 25]} entries={5} pagesAmount={4} data={datatable} searchTop searchBottom={false} />
    </MDBContainer>
  );
}


export default TopSearch
