import React, { Component } from 'react';
import { MDBContainer, MDBBtn, MDBModal, MDBModalBody, MDBModalHeader, MDBModalFooter } from 'mdbreact';
import ReactJson from 'react-json-view'

class Details extends Component {
    constructor(props) {
        super(props)
        this.state = {
            modal13: false,
            data: JSON.parse(props.data)
        }
    }
       

toggle = nr => () => {
  let modalNumber = 'modal' + nr
  this.setState({
    [modalNumber]: !this.state[modalNumber]
  });
}

render() {
  return (
  <MDBContainer>
      <MDBBtn size="sm" color="primary" onClick={this.toggle(13)}>
        Details
      </MDBBtn>
      <MDBModal isOpen={this.state.modal13} toggle={this.toggle(13)} size="lg">
        <MDBModalHeader toggle={this.toggle(13)}>
          Event Viewer Details
        </MDBModalHeader>
        <MDBModalBody className="text-left">
        <ReactJson name={false} iconStyle={"circle"} collapsed={1} src={this.state.data.Event} />
        
        </MDBModalBody>
        <MDBModalFooter>
          <MDBBtn color="elegant" onClick={this.toggle(13)}>
            Close
          </MDBBtn>
        </MDBModalFooter>
      </MDBModal>
    </MDBContainer>
    );
  }
}

export default Details;