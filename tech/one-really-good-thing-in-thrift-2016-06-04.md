# 04/06/2016 One really good thing in Thrift

What is Thrift in a few words:

* it helps to implement client-server architechure
* it is possible to create the client and the server with different progamming languages
* it has its own IDL

There are many features to say about Thrift but that's not the point of this post.
So we'll talk about Thrift's IDL and how it supports reverse compatibility of different versions of the service
interface. I'll try to explain why is it great with a simple example.

For instance, we develop the service __kitchens__(actually, I'm writing this text sitting in the kitchen):

```thrift
typedef i64 ID

exception NotFound {}

struct Kitchen {
    1: optional ID id;
    2: optional boolean has_beer_in_refregirator;
    3: optional boolean has_meat_in_refregirator;
}

struct Hostess {
    1: optional ID id;
    2: optional string name;
    3: optional string photo;
}

service kitchens {

    ID create(
        1: Kitchen kitchen
    );

    void update(
        1: kitchen kitchen
    );

    Kitchen read_by_id (
        1: ID kitchen_id
    ) throws (
        1: NotFound not_found
    );

    ID add_hostess(
        1: ID kitchen_id,
        2: Hostess hostess
    );
}
```

The serive allows us to create a new kitchen and, also, to add a new hostess.

Let's imagine that requirments changed and we want to know the age of the hostess and how good is she in cooking borscht.
Or maybe we want to know what do we have in the refregirator besides beer. We have to change __Kithen__ structure. But
what if somebody(some clients) have been using it already and, of course, we didn't plan to rewrite them.

Ok, let's say, the new structure will look so:

```thrift
struct Beer {
    1: optional string name;
    2: optional i16 count;
}

struct WhatsInRefregirator {
    1: optional list<Beer> beer;
    2: optional boolean has_meat;
}

struct Kitchen {
    1: optional ID id;
    2: optional boolean has_beer_in_refregirator_DEPRECATED;
    3: optional boolean has_meat_in_refregirator_DEPRECATED;

    100: optional WhatsInRefregirator whats_in_refregirator;
}
```

What's important to Thrift is a sequence of attributes(we keep it) and their types.

Thus, the service interface is still fittable for the old clients. We don't need to add a new structur __KitchenV2__ and
write a new method for it.
