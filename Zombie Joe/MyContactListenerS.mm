#import "MyContactListenerS.h"

MyContactListenerS::MyContactListenerS() : _contacts() {
}

MyContactListenerS::~MyContactListenerS() {
}

void MyContactListenerS::BeginContact(b2Contact* contact) {
    // We need to copy out the data because the b2Contact passed in
    // is reused.
    MyContactS myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    _contacts.push_back(myContact);
}

void MyContactListenerS::EndContact(b2Contact* contact) {
    MyContactS myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    std::vector<MyContactS>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), myContact);
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }
}

void MyContactListenerS::PreSolve(b2Contact* contact,
                                 const b2Manifold* oldManifold) {
}

void MyContactListenerS::PostSolve(b2Contact* contact,
                                  const b2ContactImpulse* impulse) {
}