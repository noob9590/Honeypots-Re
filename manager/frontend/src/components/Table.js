import React, { useEffect, useState } from 'react';
import { MDBContainer, MDBDataTableV5 } from 'mdbreact';
import { io } from "socket.io-client";
import { useAuth } from './context/auth'
import '../table.css'
import Details from './Details'
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


  useEffect(() => {
    const token = authTokens
    const socket = io.connect('/', {
      query: token,
      secure: true
    })
    socket.on('alert', (socket) => {
      const alertInfo = {
        honeypotName: socket.honeypot,
        eventId: socket.eventId,
        ipAddress: socket.ipAddress,
        workstation: socket.computerName,
        date: socket.systemTime,
        username: socket.username,
        details: <Details data={socket.data}/>
      }
      let newDatatableRows = datatable.rows
      newDatatableRows.push(alertInfo)
      setDatatable({...datatable, rows: newDatatableRows})
    })
  },[])


  return (
    <MDBContainer className="text-center" fluid>
      <MDBDataTableV5 hover entriesOptions={[5, 20, 25]} entries={5} pagesAmount={4} data={datatable} searchTop searchBottom={false} />
    </MDBContainer>
  );
}


export default TopSearch

